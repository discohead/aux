//
//  AuxMCPServer.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/21/26.
//

import Foundation
import MCP

/// MCP server that exposes all AuxKit functionality as MCP tools.
public final class AuxMCPServer: Sendable {
    private let server: Server
    private let services: ServiceContainer
    private let registry: AuxToolRegistry

    public init(services: ServiceContainer) {
        self.services = services
        self.registry = AuxToolRegistry()
        self.server = Server(
            name: "aux",
            version: Aux.version,
            instructions: "Apple Music CLI tools. Use these tools to search, browse, and control Apple Music.",
            capabilities: .init(tools: .init(listChanged: false))
        )
    }

    /// Start the MCP server on the given transport.
    public func start(transport: any Transport) async throws {
        await server.withMethodHandler(ListTools.self) { [registry] _ in
            ListTools.Result(tools: registry.mcpTools())
        }

        await server.withMethodHandler(CallTool.self) { [registry, services] params in
            guard let toolDef = registry.tool(named: params.name) else {
                return CallTool.Result(
                    content: [.text("""
                        {"error":{"code":"unknown_tool","message":"Unknown tool: \(params.name)"}}
                        """)],
                    isError: true
                )
            }
            do {
                let json = try await toolDef.execute(services, params.arguments)
                return CallTool.Result(content: [.text(json)], isError: false)
            } catch let error as AuxError {
                let errorResponse = error.toCLIErrorResponse()
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                let errorJSON = try? encoder.encode(errorResponse)
                let errorString = errorJSON.flatMap { String(data: $0, encoding: .utf8) }
                    ?? "{\"error\":{\"code\":\"internal\",\"message\":\"\(error.message)\"}}"
                return CallTool.Result(content: [.text(errorString)], isError: true)
            } catch {
                return CallTool.Result(
                    content: [.text("""
                        {"error":{"code":"internal","message":"\(error.localizedDescription)"}}
                        """)],
                    isError: true
                )
            }
        }

        try await server.start(transport: transport)
    }

    /// Block until the server's message loop finishes.
    public func waitUntilCompleted() async {
        await server.waitUntilCompleted()
    }

    /// Stop the server and disconnect the transport.
    public func stop() async {
        await server.stop()
    }
}

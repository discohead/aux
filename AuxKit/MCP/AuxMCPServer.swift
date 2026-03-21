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
            func makeErrorResult(_ error: Error) -> CallTool.Result {
                let errorResponse: CLIErrorResponse
                if let auxError = error as? AuxError {
                    errorResponse = auxError.toCLIErrorResponse()
                } else {
                    errorResponse = CLIErrorResponse(
                        code: "internal",
                        message: error.localizedDescription
                    )
                }
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                let errorString: String
                if let data = try? encoder.encode(errorResponse),
                   let json = String(data: data, encoding: .utf8) {
                    errorString = json
                } else {
                    errorString = #"{"error":{"code":"internal","message":"An unknown error occurred"}}"#
                }
                return CallTool.Result(content: [.text(errorString)], isError: true)
            }

            guard let toolDef = registry.tool(named: params.name) else {
                let errorResponse = CLIErrorResponse(
                    code: "unknown_tool",
                    message: "Unknown tool: \(params.name)"
                )
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                let errorString: String
                if let data = try? encoder.encode(errorResponse),
                   let json = String(data: data, encoding: .utf8) {
                    errorString = json
                } else {
                    errorString = #"{"error":{"code":"unknown_tool","message":"Unknown tool"}}"#
                }
                return CallTool.Result(content: [.text(errorString)], isError: true)
            }
            do {
                let json = try await toolDef.execute(services, params.arguments)
                return CallTool.Result(content: [.text(json)], isError: false)
            } catch {
                return makeErrorResult(error)
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

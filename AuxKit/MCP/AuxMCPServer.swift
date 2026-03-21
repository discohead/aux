//
//  AuxMCPServer.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/21/26.
//

import Foundation
import MCP

/// MCP server that exposes all AuxKit functionality as MCP tools.
/// Uses a ToolRegistryProtocol for tool discovery and dispatch. Errors from tool
/// execution are serialized as JSON CLIErrorResponse objects with `isError: true`.
public final class AuxMCPServer: Sendable {
    private let server: Server
    private let services: ServiceContainer
    private let registry: any ToolRegistryProtocol

    public init(services: ServiceContainer, registry: any ToolRegistryProtocol = AuxToolRegistry()) {
        self.services = services
        self.registry = registry
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
                let errorResponse = CLIErrorResponse(
                    code: "unknown_tool",
                    message: "Unknown tool: \(params.name)"
                )
                return CallTool.Result(
                    content: [.text(Self.formatErrorJSON(errorResponse, fallbackMessage: "Unknown tool"))],
                    isError: true
                )
            }
            do {
                let json = try await toolDef.execute(services, params.arguments)
                return CallTool.Result(content: [.text(json)], isError: false)
            } catch {
                let errorResponse: CLIErrorResponse
                if let auxError = error as? AuxError {
                    errorResponse = auxError.toCLIErrorResponse()
                } else {
                    errorResponse = CLIErrorResponse(
                        code: "internal",
                        message: error.localizedDescription
                    )
                }
                return CallTool.Result(
                    content: [.text(Self.formatErrorJSON(errorResponse, fallbackMessage: error.localizedDescription))],
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

    // MARK: - Private

    /// Encode a CLIErrorResponse to JSON, with a fallback that preserves the original error message.
    private static func formatErrorJSON(_ response: CLIErrorResponse, fallbackMessage: String) -> String {
        let encoder = JSONEncoder.aux
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? encoder.encode(response),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        let escaped = fallbackMessage
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        return "{\"error\":{\"code\":\"internal\",\"message\":\"\(escaped)\"}}"
    }
}

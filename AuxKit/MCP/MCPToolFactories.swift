//
//  MCPToolFactories.swift
//  AuxKit
//

import Foundation
import MCP

/// Factory functions for creating repetitive MCP tool definitions with shared patterns.
enum MCPToolFactory {

    /// Creates a standard search tool (query + limit + offset).
    static func searchTool(
        type: String,
        description: String,
        handler: @escaping @Sendable (ServiceContainer, GlobalOptions, String, Int, Int, CaptureOutputWriter) async throws -> Void
    ) -> AuxToolDefinition {
        AuxToolDefinition(
            name: "aux_search_\(type)",
            description: description,
            inputSchema: MCPSchema.object(
                properties: [
                    "query": MCPSchema.string("Search query"),
                    "limit": MCPSchema.integer("Max results (1-25)", default: 25),
                    "offset": MCPSchema.integer("Pagination offset", default: 0),
                ],
                required: ["query"]
            ),
            annotations: Tool.Annotations(readOnlyHint: true)
        ) { services, args in
            let query = try args.requireString("query")
            let limit = args.optionalInt("limit", default: 25)
            let offset = args.optionalInt("offset", default: 0)
            return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                try await handler(services, options, query, limit, offset, writer)
            }
        }
    }

    /// Creates a catalog lookup tool (required id + optional include).
    static func catalogGetById(
        type: String,
        description: String,
        handler: @escaping @Sendable (ServiceContainer, GlobalOptions, String, CaptureOutputWriter) async throws -> Void
    ) -> AuxToolDefinition {
        AuxToolDefinition(
            name: "aux_catalog_\(type)",
            description: description,
            inputSchema: MCPSchema.object(
                properties: [
                    "id": MCPSchema.string("Apple Music catalog ID"),
                ],
                required: ["id"]
            ),
            annotations: Tool.Annotations(readOnlyHint: true)
        ) { services, args in
            let id = try args.requireString("id")
            return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                try await handler(services, options, id, writer)
            }
        }
    }
}

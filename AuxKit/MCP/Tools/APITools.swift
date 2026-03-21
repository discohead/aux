import Foundation
import MCP

extension AuxToolRegistry {
    static func apiTools() -> [AuxToolDefinition] {
        [
            // MARK: - aux_api_get
            AuxToolDefinition(
                name: "aux_api_get",
                description: "Make a raw GET request to the Apple Music API",
                inputSchema: MCPSchema.object(
                    properties: [
                        "path": MCPSchema.string("API path (e.g. /v1/catalog/us/songs/123)"),
                        "query_params": MCPSchema.stringMap("Query parameters as key-value pairs"),
                    ],
                    required: ["path"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let path = try args.requireString("path")
                var queryParams: [String: String]?
                if let obj = args?["query_params"]?.objectValue {
                    queryParams = obj.reduce(into: [:]) { result, pair in
                        if let s = String(pair.value, strict: false) { result[pair.key] = s }
                    }
                }
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await APIGetHandler.handle(
                        services: services,
                        options: options,
                        path: path,
                        queryParams: queryParams,
                        writer: writer
                    )
                }
            },

            // MARK: - aux_api_post
            AuxToolDefinition(
                name: "aux_api_post",
                description: "Make a raw POST request to the Apple Music API",
                inputSchema: MCPSchema.object(
                    properties: [
                        "path": MCPSchema.string("API path (e.g. /v1/me/library)"),
                        "body": MCPSchema.string("JSON request body as a string"),
                    ],
                    required: ["path"]
                )
            ) { services, args in
                let path = try args.requireString("path")
                let body = args.optionalString("body")
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await APIPostHandler.handle(
                        services: services,
                        options: options,
                        path: path,
                        body: body,
                        writer: writer
                    )
                }
            },

            // MARK: - aux_api_put
            AuxToolDefinition(
                name: "aux_api_put",
                description: "Make a raw PUT request to the Apple Music API",
                inputSchema: MCPSchema.object(
                    properties: [
                        "path": MCPSchema.string("API path"),
                        "body": MCPSchema.string("JSON request body as a string"),
                    ],
                    required: ["path"]
                )
            ) { services, args in
                let path = try args.requireString("path")
                let body = args.optionalString("body")
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await APIPutHandler.handle(
                        services: services,
                        options: options,
                        path: path,
                        body: body,
                        writer: writer
                    )
                }
            },

            // MARK: - aux_api_delete
            AuxToolDefinition(
                name: "aux_api_delete",
                description: "Make a raw DELETE request to the Apple Music API",
                inputSchema: MCPSchema.object(
                    properties: [
                        "path": MCPSchema.string("API path"),
                    ],
                    required: ["path"]
                ),
                annotations: Tool.Annotations(destructiveHint: true)
            ) { services, args in
                let path = try args.requireString("path")
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await APIDeleteHandler.handle(
                        services: services,
                        options: options,
                        path: path,
                        writer: writer
                    )
                }
            },
        ]
    }
}

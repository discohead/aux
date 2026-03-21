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
                guard let path = args?["path"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: path")
                }
                var queryParams: [String: String]?
                if let paramsObj = args?["query_params"]?.objectValue {
                    queryParams = [:]
                    for (key, value) in paramsObj {
                        queryParams?[key] = value.stringValue ?? ""
                    }
                }
                let writer = CaptureOutputWriter()
                try await APIGetHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    path: path,
                    queryParams: queryParams,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
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
                guard let path = args?["path"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: path")
                }
                let body = args?["body"]?.stringValue
                let writer = CaptureOutputWriter()
                try await APIPostHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    path: path,
                    body: body,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
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
                guard let path = args?["path"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: path")
                }
                let body = args?["body"]?.stringValue
                let writer = CaptureOutputWriter()
                try await APIPutHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    path: path,
                    body: body,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
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
                guard let path = args?["path"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: path")
                }
                let writer = CaptureOutputWriter()
                try await APIDeleteHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    path: path,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },
        ]
    }
}

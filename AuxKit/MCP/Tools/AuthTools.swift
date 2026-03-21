import Foundation
import MCP

extension AuxToolRegistry {
    static func authTools() -> [AuxToolDefinition] {
        [
            AuxToolDefinition(
                name: "aux_auth_status",
                description: "Check Apple Music authorization status",
                inputSchema: MCPSchema.object(properties: [:]),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, _ in
                let writer = CaptureOutputWriter()
                try await AuthStatusHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            AuxToolDefinition(
                name: "aux_auth_request",
                description: "Request Apple Music authorization from the user",
                inputSchema: MCPSchema.object(properties: [:])
            ) { services, _ in
                let writer = CaptureOutputWriter()
                try await AuthRequestHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            AuxToolDefinition(
                name: "aux_auth_token",
                description:
                    "Retrieve a developer or user token for Apple Music API access",
                inputSchema: MCPSchema.object(
                    properties: [
                        "type": MCPSchema.stringEnum(
                            "Token type to retrieve",
                            values: ["developer", "user"]
                        )
                    ],
                    required: []
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let tokenType = args?["type"]?.stringValue ?? "developer"
                let writer = CaptureOutputWriter()
                try await AuthTokenHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    type: tokenType,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },
        ]
    }
}

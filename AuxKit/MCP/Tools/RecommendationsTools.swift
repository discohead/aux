import Foundation
import MCP

extension AuxToolRegistry {
    static func recommendationsTools() -> [AuxToolDefinition] {
        [
            AuxToolDefinition(
                name: "aux_recommendations_list",
                description: "Get personalized music recommendations from Apple Music",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max recommendations to return", default: 10)
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let limit = args.optionalInt("limit", default: 10)
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await RecommendationsHandler.handle(
                        services: services,
                        options: options,
                        limit: limit,
                        writer: writer
                    )
                }
            },
        ]
    }
}

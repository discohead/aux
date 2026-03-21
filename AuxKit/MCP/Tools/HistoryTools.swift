import Foundation
import MCP

extension AuxToolRegistry {
    static func historyTools() -> [AuxToolDefinition] {
        [
            // MARK: - aux_history_heavy_rotation
            AuxToolDefinition(
                name: "aux_history_heavy_rotation",
                description: "Get heavy rotation content (frequently played albums, playlists, stations)",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max items to return", default: 25)
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let limit = args.optionalInt("limit", default: 25)
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await HeavyRotationHandler.handle(
                        services: services,
                        options: options,
                        limit: limit,
                        writer: writer
                    )
                }
            },

            // MARK: - aux_history_recently_played_stations
            AuxToolDefinition(
                name: "aux_history_recently_played_stations",
                description: "Get recently played radio stations",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max stations to return", default: 25)
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let limit = args.optionalInt("limit", default: 25)
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await RecentlyPlayedStationsHandler.handle(
                        services: services,
                        options: options,
                        limit: limit,
                        writer: writer
                    )
                }
            },

            // MARK: - aux_history_recently_added
            AuxToolDefinition(
                name: "aux_history_recently_added",
                description: "Get recently added resources to the library",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max items to return", default: 25)
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let limit = args.optionalInt("limit", default: 25)
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await RecentlyAddedHandler.handle(
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

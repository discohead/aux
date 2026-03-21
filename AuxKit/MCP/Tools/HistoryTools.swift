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
                        "limit": MCPSchema.integer("Max items to return", default: 10)
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let limit = args?["limit"]?.intValue ?? 10
                let writer = CaptureOutputWriter()
                try await HeavyRotationHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    limit: limit,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_history_recently_played_stations
            AuxToolDefinition(
                name: "aux_history_recently_played_stations",
                description: "Get recently played radio stations",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max stations to return", default: 10)
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let limit = args?["limit"]?.intValue ?? 10
                let writer = CaptureOutputWriter()
                try await RecentlyPlayedStationsHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    limit: limit,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_history_recently_added
            AuxToolDefinition(
                name: "aux_history_recently_added",
                description: "Get recently added resources to the library",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max items to return", default: 10)
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let limit = args?["limit"]?.intValue ?? 10
                let writer = CaptureOutputWriter()
                try await RecentlyAddedHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    limit: limit,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },
        ]
    }
}

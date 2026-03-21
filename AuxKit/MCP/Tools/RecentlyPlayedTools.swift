import Foundation
import MCP

extension AuxToolRegistry {
    static func recentlyPlayedTools() -> [AuxToolDefinition] {
        [
            // MARK: - aux_recently_played_tracks
            AuxToolDefinition(
                name: "aux_recently_played_tracks",
                description: "Get recently played tracks from Apple Music",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max tracks to return", default: 10)
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let limit = args?["limit"]?.intValue ?? 10
                let writer = CaptureOutputWriter()
                try await RecentlyPlayedTracksHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    limit: limit,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_recently_played_containers
            AuxToolDefinition(
                name: "aux_recently_played_containers",
                description: "Get recently played containers (albums, playlists, stations) from Apple Music",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max containers to return", default: 10)
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let limit = args?["limit"]?.intValue ?? 10
                let writer = CaptureOutputWriter()
                try await RecentlyPlayedContainersHandler.handle(
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

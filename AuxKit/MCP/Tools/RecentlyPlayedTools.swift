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
                        "limit": MCPSchema.integer("Max tracks to return", default: 25)
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let limit = args.optionalInt("limit", default: 25)
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await RecentlyPlayedTracksHandler.handle(
                        services: services,
                        options: options,
                        limit: limit,
                        writer: writer
                    )
                }
            },

            // MARK: - aux_recently_played_containers
            AuxToolDefinition(
                name: "aux_recently_played_containers",
                description: "Get recently played containers (albums, playlists, stations) from Apple Music",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max containers to return", default: 25)
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                let limit = args.optionalInt("limit", default: 25)
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await RecentlyPlayedContainersHandler.handle(
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

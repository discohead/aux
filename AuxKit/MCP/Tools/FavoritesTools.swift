import Foundation
import MCP

extension AuxToolRegistry {
    static func favoritesTools() -> [AuxToolDefinition] {
        [
            AuxToolDefinition(
                name: "aux_favorites_add",
                description: "Add an item to Apple Music favorites",
                inputSchema: MCPSchema.object(
                    properties: [
                        "type": MCPSchema.string("Resource type (songs, albums, playlists, artists, music-videos, stations)"),
                        "id": MCPSchema.string("Resource ID"),
                    ],
                    required: ["type", "id"]
                )
            ) { services, args in
                let type = try args.requireString("type")
                let id = try args.requireString("id")
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await FavoritesAddHandler.handle(
                        services: services,
                        options: options,
                        type: type,
                        id: id,
                        writer: writer
                    )
                }
            },
        ]
    }
}

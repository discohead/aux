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
                let type = args?["type"]?.stringValue ?? ""
                let id = args?["id"]?.stringValue ?? ""
                let writer = CaptureOutputWriter()
                try await FavoritesAddHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    type: type,
                    id: id,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },
        ]
    }
}

import Foundation
import MCP

extension AuxToolRegistry {
    static func ratingsTools() -> [AuxToolDefinition] {
        [
            // MARK: - aux_ratings_get
            AuxToolDefinition(
                name: "aux_ratings_get",
                description: "Get the rating for a catalog or library item",
                inputSchema: MCPSchema.object(
                    properties: [
                        "type": MCPSchema.string("Resource type (e.g. songs, albums, playlists, music-videos, stations, library-songs, library-albums, library-playlists, library-music-videos)"),
                        "id": MCPSchema.string("Resource ID"),
                        "library": MCPSchema.boolean("Use library ratings instead of catalog", default: false),
                    ],
                    required: ["type", "id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, args in
                guard let type = args?["type"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: type")
                }
                guard let id = args?["id"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: id")
                }
                let library = args?["library"]?.boolValue ?? false
                let writer = CaptureOutputWriter()
                try await RatingsGetHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    type: type,
                    id: id,
                    library: library,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_ratings_set
            AuxToolDefinition(
                name: "aux_ratings_set",
                description: "Set a rating (-1 dislike, 0 neutral, 1 like) for a catalog or library item",
                inputSchema: MCPSchema.object(
                    properties: [
                        "type": MCPSchema.string("Resource type (e.g. songs, albums, playlists, music-videos, stations, library-songs, library-albums, library-playlists, library-music-videos)"),
                        "id": MCPSchema.string("Resource ID"),
                        "rating": MCPSchema.integer("Rating value: -1 (dislike), 0 (neutral), or 1 (like)"),
                        "library": MCPSchema.boolean("Use library ratings instead of catalog", default: false),
                    ],
                    required: ["type", "id", "rating"]
                )
            ) { services, args in
                guard let type = args?["type"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: type")
                }
                guard let id = args?["id"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: id")
                }
                guard let rating = args?["rating"]?.intValue else {
                    throw AuxError.usageError(message: "Missing required argument: rating")
                }
                let library = args?["library"]?.boolValue ?? false
                let writer = CaptureOutputWriter()
                try await RatingsSetHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    type: type,
                    id: id,
                    rating: rating,
                    library: library,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_ratings_delete
            AuxToolDefinition(
                name: "aux_ratings_delete",
                description: "Delete the rating for a catalog or library item",
                inputSchema: MCPSchema.object(
                    properties: [
                        "type": MCPSchema.string("Resource type (e.g. songs, albums, playlists, music-videos, stations, library-songs, library-albums, library-playlists, library-music-videos)"),
                        "id": MCPSchema.string("Resource ID"),
                        "library": MCPSchema.boolean("Use library ratings instead of catalog", default: false),
                    ],
                    required: ["type", "id"]
                ),
                annotations: Tool.Annotations(destructiveHint: true)
            ) { services, args in
                guard let type = args?["type"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: type")
                }
                guard let id = args?["id"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: id")
                }
                let library = args?["library"]?.boolValue ?? false
                let writer = CaptureOutputWriter()
                try await RatingsDeleteHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    type: type,
                    id: id,
                    library: library,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },
        ]
    }
}

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
                let type = try args.requireString("type")
                let id = try args.requireString("id")
                let library = args.optionalBool("library", default: false)
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await RatingsGetHandler.handle(
                        services: services,
                        options: options,
                        type: type,
                        id: id,
                        library: library,
                        writer: writer
                    )
                }
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
                let type = try args.requireString("type")
                let id = try args.requireString("id")
                let rating = try args.requireInt("rating")
                let library = args.optionalBool("library", default: false)
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await RatingsSetHandler.handle(
                        services: services,
                        options: options,
                        type: type,
                        id: id,
                        rating: rating,
                        library: library,
                        writer: writer
                    )
                }
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
                let type = try args.requireString("type")
                let id = try args.requireString("id")
                let library = args.optionalBool("library", default: false)
                return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                    try await RatingsDeleteHandler.handle(
                        services: services,
                        options: options,
                        type: type,
                        id: id,
                        library: library,
                        writer: writer
                    )
                }
            },
        ]
    }
}

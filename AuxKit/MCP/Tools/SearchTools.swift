import Foundation
import MCP

extension AuxToolRegistry {
    static func searchTools() -> [AuxToolDefinition] {
        [
            // MARK: - Standard search tools (query + limit + offset)
            MCPToolFactory.searchTool(type: "songs", description: "Search for songs in the Apple Music catalog") {
                services, options, query, limit, offset, writer in
                try await SearchSongsHandler.handle(services: services, options: options, query: query, limit: limit, offset: offset, writer: writer)
            },
            MCPToolFactory.searchTool(type: "albums", description: "Search for albums in the Apple Music catalog") {
                services, options, query, limit, offset, writer in
                try await SearchAlbumsHandler.handle(services: services, options: options, query: query, limit: limit, offset: offset, writer: writer)
            },
            MCPToolFactory.searchTool(type: "artists", description: "Search for artists in the Apple Music catalog") {
                services, options, query, limit, offset, writer in
                try await SearchArtistsHandler.handle(services: services, options: options, query: query, limit: limit, offset: offset, writer: writer)
            },
            MCPToolFactory.searchTool(type: "playlists", description: "Search for playlists in the Apple Music catalog") {
                services, options, query, limit, offset, writer in
                try await SearchPlaylistsHandler.handle(services: services, options: options, query: query, limit: limit, offset: offset, writer: writer)
            },
            MCPToolFactory.searchTool(type: "music_videos", description: "Search for music videos in the Apple Music catalog") {
                services, options, query, limit, offset, writer in
                try await SearchMusicVideosHandler.handle(services: services, options: options, query: query, limit: limit, offset: offset, writer: writer)
            },
            MCPToolFactory.searchTool(type: "stations", description: "Search for stations in the Apple Music catalog") {
                services, options, query, limit, offset, writer in
                try await SearchStationsHandler.handle(services: services, options: options, query: query, limit: limit, offset: offset, writer: writer)
            },
            MCPToolFactory.searchTool(type: "curators", description: "Search for curators in the Apple Music catalog") {
                services, options, query, limit, offset, writer in
                try await SearchCuratorsHandler.handle(services: services, options: options, query: query, limit: limit, offset: offset, writer: writer)
            },
            MCPToolFactory.searchTool(type: "radio_shows", description: "Search for radio shows in the Apple Music catalog") {
                services, options, query, limit, offset, writer in
                try await SearchRadioShowsHandler.handle(services: services, options: options, query: query, limit: limit, offset: offset, writer: writer)
            },

            // MARK: - aux_search_all
            AuxToolDefinition(
                name: "aux_search_all",
                description: "Search across multiple types in the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "query": MCPSchema.string("Search query"),
                        "types": MCPSchema.stringArray("Types to search (e.g. songs, albums, artists, playlists)"),
                        "limit": MCPSchema.integer("Max results per type (1-25)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                    ],
                    required: ["query"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let query = try args.requireString("query")
                    let types = args.optionalStringArray("types", default: ["songs", "albums", "artists", "playlists"])
                    let limit = args.optionalInt("limit", default: 25)
                    let offset = args.optionalInt("offset", default: 0)
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await SearchAllHandler.handle(
                            services: services, options: options,
                            query: query, types: types, limit: limit, offset: offset,
                            writer: writer
                        )
                    }
                }
            ),

            // MARK: - aux_search_suggestions
            AuxToolDefinition(
                name: "aux_search_suggestions",
                description: "Get search suggestions from the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "query": MCPSchema.string("Search query"),
                        "limit": MCPSchema.integer("Max suggestions (1-25)", default: 10),
                        "types": MCPSchema.stringArray("Types to include in suggestions"),
                    ],
                    required: ["query"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let query = try args.requireString("query")
                    let limit = args.optionalInt("limit", default: 10)
                    let types: [String]? = args?["types"]?.arrayValue?.compactMap { String($0, strict: false) }
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await SearchSuggestionsHandler.handle(
                            services: services, options: options,
                            query: query, limit: limit, types: types,
                            writer: writer
                        )
                    }
                }
            ),
        ]
    }
}

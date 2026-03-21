import Foundation
import MCP

extension AuxToolRegistry {
    static func searchTools() -> [AuxToolDefinition] {
        [
            // MARK: - aux_search_songs
            AuxToolDefinition(
                name: "aux_search_songs",
                description: "Search for songs in the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "query": MCPSchema.string("Search query"),
                        "limit": MCPSchema.integer("Max results (1-25)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                    ],
                    required: ["query"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let query = args?["query"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: query")
                    }
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let writer = CaptureOutputWriter()
                    try await SearchSongsHandler.handle(
                        services: services,
                        options: GlobalOptions(pretty: true),
                        query: query,
                        limit: limit,
                        offset: offset,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_search_albums
            AuxToolDefinition(
                name: "aux_search_albums",
                description: "Search for albums in the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "query": MCPSchema.string("Search query"),
                        "limit": MCPSchema.integer("Max results (1-25)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                    ],
                    required: ["query"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let query = args?["query"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: query")
                    }
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let writer = CaptureOutputWriter()
                    try await SearchAlbumsHandler.handle(
                        services: services,
                        options: GlobalOptions(pretty: true),
                        query: query,
                        limit: limit,
                        offset: offset,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_search_artists
            AuxToolDefinition(
                name: "aux_search_artists",
                description: "Search for artists in the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "query": MCPSchema.string("Search query"),
                        "limit": MCPSchema.integer("Max results (1-25)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                    ],
                    required: ["query"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let query = args?["query"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: query")
                    }
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let writer = CaptureOutputWriter()
                    try await SearchArtistsHandler.handle(
                        services: services,
                        options: GlobalOptions(pretty: true),
                        query: query,
                        limit: limit,
                        offset: offset,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_search_playlists
            AuxToolDefinition(
                name: "aux_search_playlists",
                description: "Search for playlists in the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "query": MCPSchema.string("Search query"),
                        "limit": MCPSchema.integer("Max results (1-25)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                    ],
                    required: ["query"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let query = args?["query"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: query")
                    }
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let writer = CaptureOutputWriter()
                    try await SearchPlaylistsHandler.handle(
                        services: services,
                        options: GlobalOptions(pretty: true),
                        query: query,
                        limit: limit,
                        offset: offset,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_search_music_videos
            AuxToolDefinition(
                name: "aux_search_music_videos",
                description: "Search for music videos in the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "query": MCPSchema.string("Search query"),
                        "limit": MCPSchema.integer("Max results (1-25)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                    ],
                    required: ["query"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let query = args?["query"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: query")
                    }
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let writer = CaptureOutputWriter()
                    try await SearchMusicVideosHandler.handle(
                        services: services,
                        options: GlobalOptions(pretty: true),
                        query: query,
                        limit: limit,
                        offset: offset,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_search_stations
            AuxToolDefinition(
                name: "aux_search_stations",
                description: "Search for stations in the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "query": MCPSchema.string("Search query"),
                        "limit": MCPSchema.integer("Max results (1-25)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                    ],
                    required: ["query"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let query = args?["query"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: query")
                    }
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let writer = CaptureOutputWriter()
                    try await SearchStationsHandler.handle(
                        services: services,
                        options: GlobalOptions(pretty: true),
                        query: query,
                        limit: limit,
                        offset: offset,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_search_curators
            AuxToolDefinition(
                name: "aux_search_curators",
                description: "Search for curators in the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "query": MCPSchema.string("Search query"),
                        "limit": MCPSchema.integer("Max results (1-25)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                    ],
                    required: ["query"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let query = args?["query"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: query")
                    }
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let writer = CaptureOutputWriter()
                    try await SearchCuratorsHandler.handle(
                        services: services,
                        options: GlobalOptions(pretty: true),
                        query: query,
                        limit: limit,
                        offset: offset,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_search_radio_shows
            AuxToolDefinition(
                name: "aux_search_radio_shows",
                description: "Search for radio shows in the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "query": MCPSchema.string("Search query"),
                        "limit": MCPSchema.integer("Max results (1-25)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                    ],
                    required: ["query"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let query = args?["query"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: query")
                    }
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let writer = CaptureOutputWriter()
                    try await SearchRadioShowsHandler.handle(
                        services: services,
                        options: GlobalOptions(pretty: true),
                        query: query,
                        limit: limit,
                        offset: offset,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

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
                    guard let query = args?["query"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: query")
                    }
                    let types = args?["types"]?.arrayValue?.compactMap(\.stringValue)
                        ?? ["songs", "albums", "artists", "playlists"]
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let writer = CaptureOutputWriter()
                    try await SearchAllHandler.handle(
                        services: services,
                        options: GlobalOptions(pretty: true),
                        query: query,
                        types: types,
                        limit: limit,
                        offset: offset,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
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
                    guard let query = args?["query"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: query")
                    }
                    let limit = args?["limit"]?.intValue ?? 10
                    let types: [String]? = args?["types"]?.arrayValue?.compactMap(\.stringValue)
                    let writer = CaptureOutputWriter()
                    try await SearchSuggestionsHandler.handle(
                        services: services,
                        options: GlobalOptions(pretty: true),
                        query: query,
                        limit: limit,
                        types: types,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),
        ]
    }
}

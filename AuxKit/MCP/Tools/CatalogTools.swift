import Foundation
import MCP

extension AuxToolRegistry {
    static func catalogTools() -> [AuxToolDefinition] {
        [
            // MARK: - aux_catalog_song
            AuxToolDefinition(
                name: "aux_catalog_song",
                description: "Get a song from the Apple Music catalog by ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "id": MCPSchema.string("Apple Music catalog song ID"),
                        "include": MCPSchema.stringArray("Related resources to include"),
                    ],
                    required: ["id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let id = args?["id"]?.stringValue ?? ""
                    let include: [String]? = args?["include"]?.arrayValue?.compactMap { $0.stringValue }
                    let writer = CaptureOutputWriter()
                    try await CatalogSongHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        id: id, include: include, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_song_by_isrc
            AuxToolDefinition(
                name: "aux_catalog_song_by_isrc",
                description: "Get songs from the Apple Music catalog by ISRC code",
                inputSchema: MCPSchema.object(
                    properties: [
                        "isrc": MCPSchema.string("ISRC code (or comma-separated ISRCs for batch lookup)"),
                    ],
                    required: ["isrc"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let isrc = args?["isrc"]?.stringValue ?? ""
                    let writer = CaptureOutputWriter()
                    try await CatalogSongByISRCHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        isrc: isrc, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_album
            AuxToolDefinition(
                name: "aux_catalog_album",
                description: "Get an album from the Apple Music catalog by ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "id": MCPSchema.string("Apple Music catalog album ID"),
                        "include": MCPSchema.stringArray("Related resources to include"),
                    ],
                    required: ["id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let id = args?["id"]?.stringValue ?? ""
                    let include: [String]? = args?["include"]?.arrayValue?.compactMap { $0.stringValue }
                    let writer = CaptureOutputWriter()
                    try await CatalogAlbumHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        id: id, include: include, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_album_by_upc
            AuxToolDefinition(
                name: "aux_catalog_album_by_upc",
                description: "Get albums from the Apple Music catalog by UPC code",
                inputSchema: MCPSchema.object(
                    properties: [
                        "upc": MCPSchema.string("UPC code (or comma-separated UPCs for batch lookup)"),
                    ],
                    required: ["upc"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let upc = args?["upc"]?.stringValue ?? ""
                    let writer = CaptureOutputWriter()
                    try await CatalogAlbumByUPCHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        upc: upc, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_artist
            AuxToolDefinition(
                name: "aux_catalog_artist",
                description: "Get an artist from the Apple Music catalog by ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "id": MCPSchema.string("Apple Music catalog artist ID"),
                        "include": MCPSchema.stringArray("Related resources to include"),
                    ],
                    required: ["id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let id = args?["id"]?.stringValue ?? ""
                    let include: [String]? = args?["include"]?.arrayValue?.compactMap { $0.stringValue }
                    let writer = CaptureOutputWriter()
                    try await CatalogArtistHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        id: id, include: include, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_playlist
            AuxToolDefinition(
                name: "aux_catalog_playlist",
                description: "Get a playlist from the Apple Music catalog by ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "id": MCPSchema.string("Apple Music catalog playlist ID"),
                        "include": MCPSchema.stringArray("Related resources to include"),
                    ],
                    required: ["id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let id = args?["id"]?.stringValue ?? ""
                    let include: [String]? = args?["include"]?.arrayValue?.compactMap { $0.stringValue }
                    let writer = CaptureOutputWriter()
                    try await CatalogPlaylistHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        id: id, include: include, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_music_video
            AuxToolDefinition(
                name: "aux_catalog_music_video",
                description: "Get a music video from the Apple Music catalog by ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "id": MCPSchema.string("Apple Music catalog music video ID"),
                    ],
                    required: ["id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let id = args?["id"]?.stringValue ?? ""
                    let writer = CaptureOutputWriter()
                    try await CatalogMusicVideoHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        id: id, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_station
            AuxToolDefinition(
                name: "aux_catalog_station",
                description: "Get a station from the Apple Music catalog by ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "id": MCPSchema.string("Apple Music catalog station ID"),
                    ],
                    required: ["id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let id = args?["id"]?.stringValue ?? ""
                    let writer = CaptureOutputWriter()
                    try await CatalogStationHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        id: id, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_curator
            AuxToolDefinition(
                name: "aux_catalog_curator",
                description: "Get a curator from the Apple Music catalog by ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "id": MCPSchema.string("Apple Music catalog curator ID"),
                    ],
                    required: ["id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let id = args?["id"]?.stringValue ?? ""
                    let writer = CaptureOutputWriter()
                    try await CatalogCuratorHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        id: id, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_radio_show
            AuxToolDefinition(
                name: "aux_catalog_radio_show",
                description: "Get a radio show from the Apple Music catalog by ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "id": MCPSchema.string("Apple Music catalog radio show ID"),
                    ],
                    required: ["id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let id = args?["id"]?.stringValue ?? ""
                    let writer = CaptureOutputWriter()
                    try await CatalogRadioShowHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        id: id, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_genre
            AuxToolDefinition(
                name: "aux_catalog_genre",
                description: "Get a genre from the Apple Music catalog by ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "id": MCPSchema.string("Apple Music catalog genre ID"),
                    ],
                    required: ["id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let id = args?["id"]?.stringValue ?? ""
                    let writer = CaptureOutputWriter()
                    try await CatalogGenreHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        id: id, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_all_genres
            AuxToolDefinition(
                name: "aux_catalog_all_genres",
                description: "Get all genres from the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [:],
                    required: []
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let writer = CaptureOutputWriter()
                    try await CatalogAllGenresHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_record_label
            AuxToolDefinition(
                name: "aux_catalog_record_label",
                description: "Get a record label from the Apple Music catalog by ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "id": MCPSchema.string("Apple Music catalog record label ID"),
                    ],
                    required: ["id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let id = args?["id"]?.stringValue ?? ""
                    let writer = CaptureOutputWriter()
                    try await CatalogRecordLabelHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        id: id, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_charts
            AuxToolDefinition(
                name: "aux_catalog_charts",
                description: "Get charts from the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "kinds": MCPSchema.stringArray("Chart kinds (e.g. most-played, city-top)"),
                        "types": MCPSchema.stringArray("Resource types (e.g. songs, albums, playlists)"),
                        "genre_id": MCPSchema.string("Genre ID to filter charts"),
                        "limit": MCPSchema.integer("Max results per chart (1-25)", default: 25),
                    ],
                    required: []
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let kinds = args?["kinds"]?.arrayValue?.compactMap { $0.stringValue } ?? []
                    let types = args?["types"]?.arrayValue?.compactMap { $0.stringValue } ?? []
                    let genreId = args?["genre_id"]?.stringValue
                    let limit = args?["limit"]?.intValue ?? 25
                    let writer = CaptureOutputWriter()
                    try await CatalogChartsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        kinds: kinds, types: types, genreId: genreId, limit: limit, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_storefront
            AuxToolDefinition(
                name: "aux_catalog_storefront",
                description: "Get a storefront from the Apple Music catalog by ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "id": MCPSchema.string("Apple Music storefront ID (e.g. us, gb, jp)"),
                    ],
                    required: ["id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let id = args?["id"]?.stringValue ?? ""
                    let writer = CaptureOutputWriter()
                    try await CatalogStorefrontHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        id: id, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_personal_station
            AuxToolDefinition(
                name: "aux_catalog_personal_station",
                description: "Get the user's personal station from the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "storefront": MCPSchema.string("Storefront ID (default: us)"),
                    ],
                    required: []
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let storefront = args?["storefront"]?.stringValue ?? "us"
                    let writer = CaptureOutputWriter()
                    try await CatalogPersonalStationHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        storefront: storefront, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_live_stations
            AuxToolDefinition(
                name: "aux_catalog_live_stations",
                description: "Get live radio stations from the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "storefront": MCPSchema.string("Storefront ID (default: us)"),
                        "limit": MCPSchema.integer("Max results (1-25)", default: 25),
                    ],
                    required: []
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let storefront = args?["storefront"]?.stringValue ?? "us"
                    let limit = args?["limit"]?.intValue ?? 25
                    let writer = CaptureOutputWriter()
                    try await CatalogLiveStationsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        storefront: storefront, limit: limit, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_station_genres
            AuxToolDefinition(
                name: "aux_catalog_station_genres",
                description: "Get station genres from the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "storefront": MCPSchema.string("Storefront ID (default: us)"),
                    ],
                    required: []
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let storefront = args?["storefront"]?.stringValue ?? "us"
                    let writer = CaptureOutputWriter()
                    try await CatalogStationGenresHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        storefront: storefront, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_stations_for_genre
            AuxToolDefinition(
                name: "aux_catalog_stations_for_genre",
                description: "Get stations for a specific genre from the Apple Music catalog",
                inputSchema: MCPSchema.object(
                    properties: [
                        "genre_id": MCPSchema.string("Station genre ID"),
                        "storefront": MCPSchema.string("Storefront ID (default: us)"),
                        "limit": MCPSchema.integer("Max results (1-25)", default: 25),
                    ],
                    required: ["genre_id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let genreId = args?["genre_id"]?.stringValue ?? ""
                    let storefront = args?["storefront"]?.stringValue ?? "us"
                    let limit = args?["limit"]?.intValue ?? 25
                    let writer = CaptureOutputWriter()
                    try await CatalogStationsForGenreHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        storefront: storefront, genreId: genreId, limit: limit, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_catalog_equivalent
            AuxToolDefinition(
                name: "aux_catalog_equivalent",
                description: "Find storefront equivalents for a song or album in a different Apple Music region",
                inputSchema: MCPSchema.object(
                    properties: [
                        "id": MCPSchema.string("Apple Music catalog ID of the song or album"),
                        "target_storefront": MCPSchema.string("Target storefront ID (e.g. gb, jp)"),
                        "type": MCPSchema.string("Resource type: songs or albums (default: songs)"),
                    ],
                    required: ["id", "target_storefront"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let id = args?["id"]?.stringValue ?? ""
                    let storefront = args?["target_storefront"]?.stringValue ?? "us"
                    let type = args?["type"]?.stringValue ?? "songs"
                    let writer = CaptureOutputWriter()
                    try await CatalogEquivalentHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        type: type, id: id, storefront: storefront, writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),
        ]
    }
}

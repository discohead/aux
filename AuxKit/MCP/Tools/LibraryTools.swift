import Foundation
import MCP

extension AuxToolRegistry {
    static func libraryTools() -> [AuxToolDefinition] {
        libraryReadTools() + libraryWriteTools()
    }

    // MARK: - Read Tools (14)

    private static func libraryReadTools() -> [AuxToolDefinition] {
        [
            // MARK: - aux_library_songs
            AuxToolDefinition(
                name: "aux_library_songs",
                description: "List songs in the user's Apple Music library with optional filtering and sorting",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max results per page (1-100)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                        "sort": MCPSchema.string("Sort field (e.g. title, artist, album, dateAdded)"),
                        "title": MCPSchema.string("Filter by title (substring match)"),
                        "artist": MCPSchema.string("Filter by artist (substring match)"),
                        "album": MCPSchema.string("Filter by album (substring match)"),
                        "downloaded_only": MCPSchema.boolean("Only show downloaded tracks", default: false),
                        "all_pages": MCPSchema.boolean("Fetch all pages automatically", default: false),
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let sort = args?["sort"]?.stringValue
                    let title = args?["title"]?.stringValue
                    let artist = args?["artist"]?.stringValue
                    let album = args?["album"]?.stringValue
                    let downloadedOnly = args?["downloaded_only"]?.boolValue ?? false
                    let allPages = args?["all_pages"]?.boolValue ?? false
                    let writer = CaptureOutputWriter()
                    try await LibrarySongsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        limit: limit, offset: offset, sort: sort,
                        title: title, artist: artist, album: album,
                        downloadedOnly: downloadedOnly, allPages: allPages,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_albums
            AuxToolDefinition(
                name: "aux_library_albums",
                description: "List albums in the user's Apple Music library with optional filtering and sorting",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max results per page (1-100)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                        "sort": MCPSchema.string("Sort field (e.g. title, artist, dateAdded)"),
                        "title": MCPSchema.string("Filter by album title (substring match)"),
                        "artist": MCPSchema.string("Filter by artist (substring match)"),
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let sort = args?["sort"]?.stringValue
                    let title = args?["title"]?.stringValue
                    let artist = args?["artist"]?.stringValue
                    let writer = CaptureOutputWriter()
                    try await LibraryAlbumsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        limit: limit, offset: offset, sort: sort,
                        title: title, artist: artist,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_artists
            AuxToolDefinition(
                name: "aux_library_artists",
                description: "List artists in the user's Apple Music library with optional filtering and sorting",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max results per page (1-100)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                        "sort": MCPSchema.string("Sort field (e.g. name, dateAdded)"),
                        "filter_name": MCPSchema.string("Filter by artist name (substring match)"),
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let sort = args?["sort"]?.stringValue
                    let filterName = args?["filter_name"]?.stringValue
                    let writer = CaptureOutputWriter()
                    try await LibraryArtistsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        limit: limit, offset: offset, sort: sort,
                        filterName: filterName,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_playlists
            AuxToolDefinition(
                name: "aux_library_playlists",
                description: "List playlists in the user's Apple Music library (MusicKit)",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max results per page (1-100)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                        "sort": MCPSchema.string("Sort field (e.g. name, dateAdded)"),
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let sort = args?["sort"]?.stringValue
                    let writer = CaptureOutputWriter()
                    try await LibraryPlaylistsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        limit: limit, offset: offset, sort: sort,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_music_videos
            AuxToolDefinition(
                name: "aux_library_music_videos",
                description: "List music videos in the user's Apple Music library",
                inputSchema: MCPSchema.object(
                    properties: [
                        "limit": MCPSchema.integer("Max results per page (1-100)", default: 25),
                        "offset": MCPSchema.integer("Pagination offset", default: 0),
                    ]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    let limit = args?["limit"]?.intValue ?? 25
                    let offset = args?["offset"]?.intValue ?? 0
                    let writer = CaptureOutputWriter()
                    try await LibraryMusicVideosHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        limit: limit, offset: offset,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_search
            AuxToolDefinition(
                name: "aux_library_search",
                description: "Search the user's Apple Music library across multiple types",
                inputSchema: MCPSchema.object(
                    properties: [
                        "query": MCPSchema.string("Search query"),
                        "types": MCPSchema.stringArray("Types to search (e.g. songs, albums, artists, playlists)"),
                        "limit": MCPSchema.integer("Max results per type (1-25)", default: 25),
                    ],
                    required: ["query"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let query = args?["query"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: query")
                    }
                    let types = args?["types"]?.arrayValue?.compactMap(\.stringValue) ?? []
                    let limit = args?["limit"]?.intValue ?? 25
                    let writer = CaptureOutputWriter()
                    try await LibrarySearchHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        query: query, types: types, limit: limit,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_get_tags
            AuxToolDefinition(
                name: "aux_library_get_tags",
                description: "Get metadata tags for a track in Music.app by database ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Music.app database ID of the track"),
                    ],
                    required: ["track_id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let trackId = args?["track_id"]?.intValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_id")
                    }
                    let writer = CaptureOutputWriter()
                    try await LibraryGetTagsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackId: trackId,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_get_lyrics
            AuxToolDefinition(
                name: "aux_library_get_lyrics",
                description: "Get lyrics for a track in Music.app by database ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Music.app database ID of the track"),
                    ],
                    required: ["track_id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let trackId = args?["track_id"]?.intValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_id")
                    }
                    let writer = CaptureOutputWriter()
                    try await LibraryGetLyricsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackId: trackId,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_get_artwork
            AuxToolDefinition(
                name: "aux_library_get_artwork",
                description: "Get artwork data for a track in Music.app by database ID",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Music.app database ID of the track"),
                        "index": MCPSchema.integer("Artwork index (1-based)", default: 1),
                    ],
                    required: ["track_id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let trackId = args?["track_id"]?.intValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_id")
                    }
                    let index = args?["index"]?.intValue ?? 1
                    let writer = CaptureOutputWriter()
                    try await LibraryGetArtworkHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackId: trackId, index: index,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_get_artwork_count
            AuxToolDefinition(
                name: "aux_library_get_artwork_count",
                description: "Get the number of artwork images for a track in Music.app",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Music.app database ID of the track"),
                    ],
                    required: ["track_id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let trackId = args?["track_id"]?.intValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_id")
                    }
                    let writer = CaptureOutputWriter()
                    try await LibraryGetArtworkCountHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackId: trackId,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_get_file_info
            AuxToolDefinition(
                name: "aux_library_get_file_info",
                description: "Get file information (path, size, format) for a track in Music.app",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Music.app database ID of the track"),
                    ],
                    required: ["track_id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let trackId = args?["track_id"]?.intValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_id")
                    }
                    let writer = CaptureOutputWriter()
                    try await LibraryGetFileInfoHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackId: trackId,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_get_play_stats
            AuxToolDefinition(
                name: "aux_library_get_play_stats",
                description: "Get play statistics (play count, skip count, last played) for a track",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Music.app database ID of the track"),
                    ],
                    required: ["track_id"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let trackId = args?["track_id"]?.intValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_id")
                    }
                    let writer = CaptureOutputWriter()
                    try await LibraryGetPlayStatsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackId: trackId,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_list_playlists
            AuxToolDefinition(
                name: "aux_library_list_playlists",
                description: "List all playlists in Music.app via AppleScript (includes folder hierarchy)",
                inputSchema: MCPSchema.object(
                    properties: [:]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, _ in
                    let writer = CaptureOutputWriter()
                    try await LibraryListPlaylistsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_find_duplicates
            AuxToolDefinition(
                name: "aux_library_find_duplicates",
                description: "Find duplicate tracks in a playlist by matching title and artist",
                inputSchema: MCPSchema.object(
                    properties: [
                        "playlist_name": MCPSchema.string("Name of the playlist to check for duplicates"),
                    ],
                    required: ["playlist_name"]
                ),
                annotations: Tool.Annotations(readOnlyHint: true),
                execute: { services, args in
                    guard let playlistName = args?["playlist_name"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: playlist_name")
                    }
                    let writer = CaptureOutputWriter()
                    try await LibraryFindDuplicatesHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        playlistName: playlistName,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),
        ]
    }

    // MARK: - Write Tools (16)

    private static func libraryWriteTools() -> [AuxToolDefinition] {
        [
            // MARK: - aux_library_add
            AuxToolDefinition(
                name: "aux_library_add",
                description: "Add items from the Apple Music catalog to the user's library",
                inputSchema: MCPSchema.object(
                    properties: [
                        "ids": MCPSchema.stringArray("Apple Music catalog IDs to add"),
                        "type": MCPSchema.string("Resource type (e.g. songs, albums, playlists)"),
                    ],
                    required: ["ids", "type"]
                ),
                execute: { services, args in
                    guard let idsArray = args?["ids"]?.arrayValue else {
                        throw AuxError.usageError(message: "Missing required argument: ids")
                    }
                    let ids = idsArray.compactMap(\.stringValue)
                    guard let type = args?["type"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: type")
                    }
                    let writer = CaptureOutputWriter()
                    try await LibraryAddHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        ids: ids, type: type,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_create_playlist
            AuxToolDefinition(
                name: "aux_library_create_playlist",
                description: "Create a new playlist in the user's Apple Music library",
                inputSchema: MCPSchema.object(
                    properties: [
                        "name": MCPSchema.string("Playlist name"),
                        "description": MCPSchema.string("Playlist description"),
                        "track_ids": MCPSchema.stringArray("Catalog track IDs to add to the new playlist"),
                    ],
                    required: ["name"]
                ),
                execute: { services, args in
                    guard let name = args?["name"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: name")
                    }
                    let description = args?["description"]?.stringValue
                    let trackIds = args?["track_ids"]?.arrayValue?.compactMap(\.stringValue) ?? []
                    let writer = CaptureOutputWriter()
                    try await LibraryCreatePlaylistHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        name: name, description: description, trackIds: trackIds,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_add_to_playlist
            AuxToolDefinition(
                name: "aux_library_add_to_playlist",
                description: "Add tracks to an existing playlist in the user's Apple Music library",
                inputSchema: MCPSchema.object(
                    properties: [
                        "playlist_id": MCPSchema.string("Library playlist ID"),
                        "track_ids": MCPSchema.stringArray("Track IDs to add to the playlist"),
                    ],
                    required: ["playlist_id", "track_ids"]
                ),
                execute: { services, args in
                    guard let playlistId = args?["playlist_id"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: playlist_id")
                    }
                    guard let trackIdsArray = args?["track_ids"]?.arrayValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_ids")
                    }
                    let trackIds = trackIdsArray.compactMap(\.stringValue)
                    let writer = CaptureOutputWriter()
                    try await LibraryAddToPlaylistHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        playlistId: playlistId, trackIds: trackIds,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_set_tags
            AuxToolDefinition(
                name: "aux_library_set_tags",
                description: "Set metadata tags on a track in Music.app (title, artist, album, genre, etc.)",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Music.app database ID of the track"),
                        "fields": MCPSchema.stringMap("Tag fields to set (e.g. {\"name\": \"New Title\", \"artist\": \"Artist\"})"),
                    ],
                    required: ["track_id", "fields"]
                ),
                execute: { services, args in
                    guard let trackId = args?["track_id"]?.intValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_id")
                    }
                    guard let fieldsObj = args?["fields"]?.objectValue else {
                        throw AuxError.usageError(message: "Missing required argument: fields")
                    }
                    let fields: [String: String] = fieldsObj.reduce(into: [:]) { result, pair in
                        if let str = pair.value.stringValue { result[pair.key] = str }
                    }
                    let writer = CaptureOutputWriter()
                    try await LibrarySetTagsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackId: trackId, fields: fields,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_batch_set_tags
            AuxToolDefinition(
                name: "aux_library_batch_set_tags",
                description: "Set metadata tags on multiple tracks in Music.app at once",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_ids": MCPSchema.intArray("Music.app database IDs of the tracks"),
                        "fields": MCPSchema.stringMap("Tag fields to set on all tracks"),
                    ],
                    required: ["track_ids", "fields"]
                ),
                execute: { services, args in
                    guard let trackIdsArray = args?["track_ids"]?.arrayValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_ids")
                    }
                    let trackIds = trackIdsArray.compactMap(\.intValue)
                    guard let fieldsObj = args?["fields"]?.objectValue else {
                        throw AuxError.usageError(message: "Missing required argument: fields")
                    }
                    let fields: [String: String] = fieldsObj.reduce(into: [:]) { result, pair in
                        if let str = pair.value.stringValue { result[pair.key] = str }
                    }
                    let writer = CaptureOutputWriter()
                    try await LibraryBatchSetTagsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackIds: trackIds, fields: fields,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_set_lyrics
            AuxToolDefinition(
                name: "aux_library_set_lyrics",
                description: "Set lyrics text on a track in Music.app",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Music.app database ID of the track"),
                        "text": MCPSchema.string("Lyrics text to set"),
                    ],
                    required: ["track_id", "text"]
                ),
                execute: { services, args in
                    guard let trackId = args?["track_id"]?.intValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_id")
                    }
                    guard let text = args?["text"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: text")
                    }
                    let writer = CaptureOutputWriter()
                    try await LibrarySetLyricsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackId: trackId, text: text,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_set_artwork
            AuxToolDefinition(
                name: "aux_library_set_artwork",
                description: "Set artwork image on a track in Music.app from a file path",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Music.app database ID of the track"),
                        "image_path": MCPSchema.string("Path to the artwork image file"),
                    ],
                    required: ["track_id", "image_path"]
                ),
                execute: { services, args in
                    guard let trackId = args?["track_id"]?.intValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_id")
                    }
                    guard let imagePath = args?["image_path"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: image_path")
                    }
                    let writer = CaptureOutputWriter()
                    try await LibrarySetArtworkHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackId: trackId, imagePath: imagePath,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_set_play_stats
            AuxToolDefinition(
                name: "aux_library_set_play_stats",
                description: "Set play statistics on a track in Music.app (play count, skip count, etc.)",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Music.app database ID of the track"),
                        "fields": MCPSchema.stringMap("Play stat fields to set (e.g. {\"played_count\": \"5\"})"),
                    ],
                    required: ["track_id", "fields"]
                ),
                execute: { services, args in
                    guard let trackId = args?["track_id"]?.intValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_id")
                    }
                    guard let fieldsObj = args?["fields"]?.objectValue else {
                        throw AuxError.usageError(message: "Missing required argument: fields")
                    }
                    let fields: [String: String] = fieldsObj.reduce(into: [:]) { result, pair in
                        if let str = pair.value.stringValue { result[pair.key] = str }
                    }
                    let writer = CaptureOutputWriter()
                    try await LibrarySetPlayStatsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackId: trackId, fields: fields,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_reset_play_stats
            AuxToolDefinition(
                name: "aux_library_reset_play_stats",
                description: "Reset play statistics for one or more tracks in Music.app",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_ids": MCPSchema.intArray("Music.app database IDs of the tracks"),
                    ],
                    required: ["track_ids"]
                ),
                annotations: Tool.Annotations(destructiveHint: true),
                execute: { services, args in
                    guard let trackIdsArray = args?["track_ids"]?.arrayValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_ids")
                    }
                    let trackIds = trackIdsArray.compactMap(\.intValue)
                    let writer = CaptureOutputWriter()
                    try await LibraryResetPlayStatsHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackIds: trackIds,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_reveal
            AuxToolDefinition(
                name: "aux_library_reveal",
                description: "Reveal a track's file in Finder via Music.app",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Music.app database ID of the track"),
                    ],
                    required: ["track_id"]
                ),
                execute: { services, args in
                    guard let trackId = args?["track_id"]?.intValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_id")
                    }
                    let writer = CaptureOutputWriter()
                    try await LibraryRevealHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackId: trackId,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_delete
            AuxToolDefinition(
                name: "aux_library_delete",
                description: "Delete tracks from Music.app library",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_ids": MCPSchema.intArray("Music.app database IDs of the tracks to delete"),
                    ],
                    required: ["track_ids"]
                ),
                annotations: Tool.Annotations(destructiveHint: true),
                execute: { services, args in
                    guard let trackIdsArray = args?["track_ids"]?.arrayValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_ids")
                    }
                    let trackIds = trackIdsArray.compactMap(\.intValue)
                    let writer = CaptureOutputWriter()
                    try await LibraryDeleteHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackIds: trackIds,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_convert
            AuxToolDefinition(
                name: "aux_library_convert",
                description: "Convert tracks to the preferred encoder format in Music.app",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_ids": MCPSchema.intArray("Music.app database IDs of the tracks to convert"),
                    ],
                    required: ["track_ids"]
                ),
                execute: { services, args in
                    guard let trackIdsArray = args?["track_ids"]?.arrayValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_ids")
                    }
                    let trackIds = trackIdsArray.compactMap(\.intValue)
                    let writer = CaptureOutputWriter()
                    try await LibraryConvertHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        trackIds: trackIds,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_import
            AuxToolDefinition(
                name: "aux_library_import",
                description: "Import audio files into Music.app library, optionally into a playlist",
                inputSchema: MCPSchema.object(
                    properties: [
                        "paths": MCPSchema.stringArray("File paths to import"),
                        "to_playlist": MCPSchema.string("Optional playlist name to add imported tracks to"),
                    ],
                    required: ["paths"]
                ),
                execute: { services, args in
                    guard let pathsArray = args?["paths"]?.arrayValue else {
                        throw AuxError.usageError(message: "Missing required argument: paths")
                    }
                    let paths = pathsArray.compactMap(\.stringValue)
                    let toPlaylist = args?["to_playlist"]?.stringValue
                    let writer = CaptureOutputWriter()
                    try await LibraryImportHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        paths: paths, toPlaylist: toPlaylist,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_delete_playlist
            AuxToolDefinition(
                name: "aux_library_delete_playlist",
                description: "Delete a playlist from Music.app by name",
                inputSchema: MCPSchema.object(
                    properties: [
                        "name": MCPSchema.string("Name of the playlist to delete"),
                    ],
                    required: ["name"]
                ),
                annotations: Tool.Annotations(destructiveHint: true),
                execute: { services, args in
                    guard let name = args?["name"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: name")
                    }
                    let writer = CaptureOutputWriter()
                    try await LibraryDeletePlaylistHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        name: name,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_rename_playlist
            AuxToolDefinition(
                name: "aux_library_rename_playlist",
                description: "Rename a playlist in Music.app",
                inputSchema: MCPSchema.object(
                    properties: [
                        "name": MCPSchema.string("Current name of the playlist"),
                        "new_name": MCPSchema.string("New name for the playlist"),
                    ],
                    required: ["name", "new_name"]
                ),
                execute: { services, args in
                    guard let name = args?["name"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: name")
                    }
                    guard let newName = args?["new_name"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: new_name")
                    }
                    let writer = CaptureOutputWriter()
                    try await LibraryRenamePlaylistHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        name: name, newName: newName,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_remove_from_playlist
            AuxToolDefinition(
                name: "aux_library_remove_from_playlist",
                description: "Remove tracks from a playlist in Music.app",
                inputSchema: MCPSchema.object(
                    properties: [
                        "playlist_name": MCPSchema.string("Name of the playlist"),
                        "track_ids": MCPSchema.intArray("Music.app database IDs of the tracks to remove"),
                    ],
                    required: ["playlist_name", "track_ids"]
                ),
                execute: { services, args in
                    guard let playlistName = args?["playlist_name"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: playlist_name")
                    }
                    guard let trackIdsArray = args?["track_ids"]?.arrayValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_ids")
                    }
                    let trackIds = trackIdsArray.compactMap(\.intValue)
                    let writer = CaptureOutputWriter()
                    try await LibraryRemoveFromPlaylistHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        playlistName: playlistName, trackIds: trackIds,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),

            // MARK: - aux_library_reorder_tracks
            AuxToolDefinition(
                name: "aux_library_reorder_tracks",
                description: "Reorder tracks in a playlist in Music.app",
                inputSchema: MCPSchema.object(
                    properties: [
                        "playlist_name": MCPSchema.string("Name of the playlist"),
                        "track_ids": MCPSchema.intArray("Music.app database IDs in the desired order"),
                    ],
                    required: ["playlist_name", "track_ids"]
                ),
                execute: { services, args in
                    guard let playlistName = args?["playlist_name"]?.stringValue else {
                        throw AuxError.usageError(message: "Missing required argument: playlist_name")
                    }
                    guard let trackIdsArray = args?["track_ids"]?.arrayValue else {
                        throw AuxError.usageError(message: "Missing required argument: track_ids")
                    }
                    let trackIds = trackIdsArray.compactMap(\.intValue)
                    let writer = CaptureOutputWriter()
                    try await LibraryReorderTracksHandler.handle(
                        services: services, options: GlobalOptions(pretty: true),
                        playlistName: playlistName, trackIds: trackIds,
                        writer: writer
                    )
                    return writer.capturedString ?? "{}"
                }
            ),
        ]
    }
}

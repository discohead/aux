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
                    let limit = args.optionalInt("limit", default: 25)
                    let offset = args.optionalInt("offset", default: 0)
                    let sort = args.optionalString("sort")
                    let title = args.optionalString("title")
                    let artist = args.optionalString("artist")
                    let album = args.optionalString("album")
                    let downloadedOnly = args.optionalBool("downloaded_only", default: false)
                    let allPages = args.optionalBool("all_pages", default: false)
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibrarySongsHandler.handle(
                            services: services, options: options,
                            limit: limit, offset: offset, sort: sort,
                            title: title, artist: artist, album: album,
                            downloadedOnly: downloadedOnly, allPages: allPages,
                            writer: writer
                        )
                    }
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
                    let limit = args.optionalInt("limit", default: 25)
                    let offset = args.optionalInt("offset", default: 0)
                    let sort = args.optionalString("sort")
                    let title = args.optionalString("title")
                    let artist = args.optionalString("artist")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryAlbumsHandler.handle(
                            services: services, options: options,
                            limit: limit, offset: offset, sort: sort,
                            title: title, artist: artist,
                            writer: writer
                        )
                    }
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
                    let limit = args.optionalInt("limit", default: 25)
                    let offset = args.optionalInt("offset", default: 0)
                    let sort = args.optionalString("sort")
                    let filterName = args.optionalString("filter_name")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryArtistsHandler.handle(
                            services: services, options: options,
                            limit: limit, offset: offset, sort: sort,
                            filterName: filterName,
                            writer: writer
                        )
                    }
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
                    let limit = args.optionalInt("limit", default: 25)
                    let offset = args.optionalInt("offset", default: 0)
                    let sort = args.optionalString("sort")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryPlaylistsHandler.handle(
                            services: services, options: options,
                            limit: limit, offset: offset, sort: sort,
                            writer: writer
                        )
                    }
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
                    let limit = args.optionalInt("limit", default: 25)
                    let offset = args.optionalInt("offset", default: 0)
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryMusicVideosHandler.handle(
                            services: services, options: options,
                            limit: limit, offset: offset,
                            writer: writer
                        )
                    }
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
                    let query = try args.requireString("query")
                    let types = args.optionalStringArray("types", default: [])
                    let limit = args.optionalInt("limit", default: 25)
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibrarySearchHandler.handle(
                            services: services, options: options,
                            query: query, types: types, limit: limit,
                            writer: writer
                        )
                    }
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
                    let trackId = try args.requireInt("track_id")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryGetTagsHandler.handle(
                            services: services, options: options,
                            trackId: trackId,
                            writer: writer
                        )
                    }
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
                    let trackId = try args.requireInt("track_id")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryGetLyricsHandler.handle(
                            services: services, options: options,
                            trackId: trackId,
                            writer: writer
                        )
                    }
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
                    let trackId = try args.requireInt("track_id")
                    let index = args.optionalInt("index", default: 1)
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryGetArtworkHandler.handle(
                            services: services, options: options,
                            trackId: trackId, index: index,
                            writer: writer
                        )
                    }
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
                    let trackId = try args.requireInt("track_id")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryGetArtworkCountHandler.handle(
                            services: services, options: options,
                            trackId: trackId,
                            writer: writer
                        )
                    }
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
                    let trackId = try args.requireInt("track_id")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryGetFileInfoHandler.handle(
                            services: services, options: options,
                            trackId: trackId,
                            writer: writer
                        )
                    }
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
                    let trackId = try args.requireInt("track_id")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryGetPlayStatsHandler.handle(
                            services: services, options: options,
                            trackId: trackId,
                            writer: writer
                        )
                    }
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
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryListPlaylistsHandler.handle(
                            services: services, options: options,
                            writer: writer
                        )
                    }
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
                    let playlistName = try args.requireString("playlist_name")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryFindDuplicatesHandler.handle(
                            services: services, options: options,
                            playlistName: playlistName,
                            writer: writer
                        )
                    }
                }
            ),
        ]
    }

    // MARK: - Write Tools (17)

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
                    let ids = try args.requireStringArray("ids")
                    let type = try args.requireString("type")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryAddHandler.handle(
                            services: services, options: options,
                            ids: ids, type: type,
                            writer: writer
                        )
                    }
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
                    let name = try args.requireString("name")
                    let description = args.optionalString("description")
                    let trackIds = args.optionalStringArray("track_ids", default: [])
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryCreatePlaylistHandler.handle(
                            services: services, options: options,
                            name: name, description: description, trackIds: trackIds,
                            writer: writer
                        )
                    }
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
                    let playlistId = try args.requireString("playlist_id")
                    let trackIds = try args.requireStringArray("track_ids")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryAddToPlaylistHandler.handle(
                            services: services, options: options,
                            playlistId: playlistId, trackIds: trackIds,
                            writer: writer
                        )
                    }
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
                    let trackId = try args.requireInt("track_id")
                    let fields = try args.requireStringMap("fields")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibrarySetTagsHandler.handle(
                            services: services, options: options,
                            trackId: trackId, fields: fields,
                            writer: writer
                        )
                    }
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
                    let trackIds = try args.requireIntArray("track_ids")
                    let fields = try args.requireStringMap("fields")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryBatchSetTagsHandler.handle(
                            services: services, options: options,
                            trackIds: trackIds, fields: fields,
                            writer: writer
                        )
                    }
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
                    let trackId = try args.requireInt("track_id")
                    let text = try args.requireString("text")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibrarySetLyricsHandler.handle(
                            services: services, options: options,
                            trackId: trackId, text: text,
                            writer: writer
                        )
                    }
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
                    let trackId = try args.requireInt("track_id")
                    let imagePath = try args.requireString("image_path")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibrarySetArtworkHandler.handle(
                            services: services, options: options,
                            trackId: trackId, imagePath: imagePath,
                            writer: writer
                        )
                    }
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
                    let trackId = try args.requireInt("track_id")
                    let fields = try args.requireStringMap("fields")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibrarySetPlayStatsHandler.handle(
                            services: services, options: options,
                            trackId: trackId, fields: fields,
                            writer: writer
                        )
                    }
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
                    let trackIds = try args.requireIntArray("track_ids")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryResetPlayStatsHandler.handle(
                            services: services, options: options,
                            trackIds: trackIds,
                            writer: writer
                        )
                    }
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
                    let trackId = try args.requireInt("track_id")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryRevealHandler.handle(
                            services: services, options: options,
                            trackId: trackId,
                            writer: writer
                        )
                    }
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
                    let trackIds = try args.requireIntArray("track_ids")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryDeleteHandler.handle(
                            services: services, options: options,
                            trackIds: trackIds,
                            writer: writer
                        )
                    }
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
                    let trackIds = try args.requireIntArray("track_ids")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryConvertHandler.handle(
                            services: services, options: options,
                            trackIds: trackIds,
                            writer: writer
                        )
                    }
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
                    let paths = try args.requireStringArray("paths")
                    let toPlaylist = args.optionalString("to_playlist")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryImportHandler.handle(
                            services: services, options: options,
                            paths: paths, toPlaylist: toPlaylist,
                            writer: writer
                        )
                    }
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
                    let name = try args.requireString("name")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryDeletePlaylistHandler.handle(
                            services: services, options: options,
                            name: name,
                            writer: writer
                        )
                    }
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
                    let name = try args.requireString("name")
                    let newName = try args.requireString("new_name")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryRenamePlaylistHandler.handle(
                            services: services, options: options,
                            name: name, newName: newName,
                            writer: writer
                        )
                    }
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
                    let playlistName = try args.requireString("playlist_name")
                    let trackIds = try args.requireIntArray("track_ids")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryRemoveFromPlaylistHandler.handle(
                            services: services, options: options,
                            playlistName: playlistName, trackIds: trackIds,
                            writer: writer
                        )
                    }
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
                    let playlistName = try args.requireString("playlist_name")
                    let trackIds = try args.requireIntArray("track_ids")
                    return try await CaptureOutputWriter.capture(services: services) { services, options, writer in
                        try await LibraryReorderTracksHandler.handle(
                            services: services, options: options,
                            playlistName: playlistName, trackIds: trackIds,
                            writer: writer
                        )
                    }
                }
            ),
        ]
    }
}

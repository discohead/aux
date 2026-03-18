//
//  ServiceResults.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

// MARK: - SearchAllResult

public struct SearchAllResult: Codable, Equatable, Sendable {
    public let songs: [SongDTO]?
    public let albums: [AlbumDTO]?
    public let artists: [ArtistDTO]?
    public let playlists: [PlaylistDTO]?
    public let musicVideos: [MusicVideoDTO]?
    public let stations: [StationDTO]?
    public let curators: [CuratorDTO]?
    public let radioShows: [RadioShowDTO]?
    public let topResults: [TopResultDTO]?

    enum CodingKeys: String, CodingKey {
        case songs, albums, artists, playlists, stations, curators
        case musicVideos = "music_videos"
        case radioShows = "radio_shows"
        case topResults = "top_results"
    }

    public init(
        songs: [SongDTO]? = nil,
        albums: [AlbumDTO]? = nil,
        artists: [ArtistDTO]? = nil,
        playlists: [PlaylistDTO]? = nil,
        musicVideos: [MusicVideoDTO]? = nil,
        stations: [StationDTO]? = nil,
        curators: [CuratorDTO]? = nil,
        radioShows: [RadioShowDTO]? = nil,
        topResults: [TopResultDTO]? = nil
    ) {
        self.songs = songs
        self.albums = albums
        self.artists = artists
        self.playlists = playlists
        self.musicVideos = musicVideos
        self.stations = stations
        self.curators = curators
        self.radioShows = radioShows
        self.topResults = topResults
    }
}

// MARK: - ChartsResult

public struct ChartEntry: Codable, Equatable, Sendable {
    public let title: String
    public let kind: String
    public let songs: [SongDTO]?
    public let albums: [AlbumDTO]?
    public let playlists: [PlaylistDTO]?
    public let musicVideos: [MusicVideoDTO]?

    enum CodingKeys: String, CodingKey {
        case title, kind, songs, albums, playlists
        case musicVideos = "music_videos"
    }

    public init(
        title: String,
        kind: String,
        songs: [SongDTO]? = nil,
        albums: [AlbumDTO]? = nil,
        playlists: [PlaylistDTO]? = nil,
        musicVideos: [MusicVideoDTO]? = nil
    ) {
        self.title = title
        self.kind = kind
        self.songs = songs
        self.albums = albums
        self.playlists = playlists
        self.musicVideos = musicVideos
    }
}

public struct ChartsResult: Codable, Equatable, Sendable {
    public let charts: [ChartEntry]

    public init(charts: [ChartEntry]) {
        self.charts = charts
    }
}

// MARK: - SuggestionsResult

public struct SuggestionsResult: Codable, Equatable, Sendable {
    public let terms: [String]
    public let topResults: [TopResultDTO]?

    enum CodingKeys: String, CodingKey {
        case terms
        case topResults = "top_results"
    }

    public init(terms: [String], topResults: [TopResultDTO]? = nil) {
        self.terms = terms
        self.topResults = topResults
    }
}

// MARK: - LibrarySearchResult

public struct LibrarySearchResult: Codable, Equatable, Sendable {
    public let songs: [SongDTO]?
    public let albums: [AlbumDTO]?
    public let artists: [ArtistDTO]?
    public let playlists: [PlaylistDTO]?
    public let musicVideos: [MusicVideoDTO]?

    enum CodingKeys: String, CodingKey {
        case songs, albums, artists, playlists
        case musicVideos = "music_videos"
    }

    public init(
        songs: [SongDTO]? = nil,
        albums: [AlbumDTO]? = nil,
        artists: [ArtistDTO]? = nil,
        playlists: [PlaylistDTO]? = nil,
        musicVideos: [MusicVideoDTO]? = nil
    ) {
        self.songs = songs
        self.albums = albums
        self.artists = artists
        self.playlists = playlists
        self.musicVideos = musicVideos
    }
}

// MARK: - AuthStatusResult

public struct SubscriptionInfo: Codable, Equatable, Sendable {
    public let canPlayCatalogContent: Bool
    public let canBecomeSubscriber: Bool
    public let hasCloudLibraryEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case canPlayCatalogContent = "can_play_catalog_content"
        case canBecomeSubscriber = "can_become_subscriber"
        case hasCloudLibraryEnabled = "has_cloud_library_enabled"
    }

    public init(
        canPlayCatalogContent: Bool,
        canBecomeSubscriber: Bool,
        hasCloudLibraryEnabled: Bool
    ) {
        self.canPlayCatalogContent = canPlayCatalogContent
        self.canBecomeSubscriber = canBecomeSubscriber
        self.hasCloudLibraryEnabled = hasCloudLibraryEnabled
    }
}

public struct AuthStatusResult: Codable, Equatable, Sendable {
    public let authorizationStatus: String
    public let subscription: SubscriptionInfo?
    public let countryCode: String?

    enum CodingKeys: String, CodingKey {
        case authorizationStatus = "authorization_status"
        case subscription
        case countryCode = "country_code"
    }

    public init(authorizationStatus: String, subscription: SubscriptionInfo? = nil, countryCode: String? = nil) {
        self.authorizationStatus = authorizationStatus
        self.subscription = subscription
        self.countryCode = countryCode
    }
}

// MARK: - TokenResult

public struct TokenResult: Codable, Equatable, Sendable {
    public let developerToken: String?
    public let userToken: String?
    public let message: String?

    enum CodingKeys: String, CodingKey {
        case developerToken = "developer_token"
        case userToken = "user_token"
        case message
    }

    public init(developerToken: String? = nil, userToken: String? = nil, message: String? = nil) {
        self.developerToken = developerToken
        self.userToken = userToken
        self.message = message
    }
}

// MARK: - RecommendationsResult

public struct RecommendationGroup: Codable, Equatable, Sendable {
    public let title: String?
    public let types: [String]
    public let albums: [AlbumDTO]?
    public let playlists: [PlaylistDTO]?
    public let stations: [StationDTO]?

    public init(
        title: String? = nil,
        types: [String],
        albums: [AlbumDTO]? = nil,
        playlists: [PlaylistDTO]? = nil,
        stations: [StationDTO]? = nil
    ) {
        self.title = title
        self.types = types
        self.albums = albums
        self.playlists = playlists
        self.stations = stations
    }
}

public struct RecommendationsResult: Codable, Equatable, Sendable {
    public let recommendations: [RecommendationGroup]

    public init(recommendations: [RecommendationGroup]) {
        self.recommendations = recommendations
    }
}

// MARK: - RecentlyPlayedContainersResult

public struct RecentlyPlayedContainer: Codable, Equatable, Sendable {
    public let type: String
    public let id: String
    public let name: String?

    public init(type: String, id: String, name: String? = nil) {
        self.type = type
        self.id = id
        self.name = name
    }
}

public struct RecentlyPlayedContainersResult: Codable, Equatable, Sendable {
    public let items: [RecentlyPlayedContainer]

    public init(items: [RecentlyPlayedContainer]) {
        self.items = items
    }
}

// MARK: - PlayerStatusResult

public struct PlayerStatusResult: Codable, Equatable, Sendable {
    public let state: String
    public let shuffleMode: String?
    public let repeatMode: String?
    public let volume: Double?
    public let airPlayEnabled: Bool?

    enum CodingKeys: String, CodingKey {
        case state, volume
        case shuffleMode = "shuffle_mode"
        case repeatMode = "repeat_mode"
        case airPlayEnabled = "air_play_enabled"
    }

    public init(
        state: String,
        shuffleMode: String? = nil,
        repeatMode: String? = nil,
        volume: Double? = nil,
        airPlayEnabled: Bool? = nil
    ) {
        self.state = state
        self.shuffleMode = shuffleMode
        self.repeatMode = repeatMode
        self.volume = volume
        self.airPlayEnabled = airPlayEnabled
    }
}

// MARK: - AirPlayDeviceResult

public struct AirPlayDevice: Codable, Equatable, Sendable {
    public let name: String
    public let kind: String?
    public let active: Bool

    public init(name: String, kind: String? = nil, active: Bool) {
        self.name = name
        self.kind = kind
        self.active = active
    }
}

public struct AirPlayDeviceResult: Codable, Equatable, Sendable {
    public let devices: [AirPlayDevice]

    public init(devices: [AirPlayDevice]) {
        self.devices = devices
    }
}

// MARK: - ImportResult

public struct ImportedTrack: Codable, Equatable, Sendable {
    public let databaseId: Int
    public let name: String
    public let filePath: String

    enum CodingKeys: String, CodingKey {
        case databaseId = "database_id"
        case name
        case filePath = "file_path"
    }

    public init(databaseId: Int, name: String, filePath: String) {
        self.databaseId = databaseId
        self.name = name
        self.filePath = filePath
    }
}

public struct ImportResult: Codable, Equatable, Sendable {
    public let imported: Bool
    public let fileCount: Int
    public let tracks: [ImportedTrack]?

    enum CodingKeys: String, CodingKey {
        case imported, tracks
        case fileCount = "file_count"
    }

    public init(imported: Bool, fileCount: Int, tracks: [ImportedTrack]? = nil) {
        self.imported = imported
        self.fileCount = fileCount
        self.tracks = tracks
    }
}

// MARK: - ArtworkResult

public struct ArtworkResult: Codable, Equatable, Sendable {
    public let databaseId: Int
    public let artworkCount: Int
    public let format: String?
    public let filePath: String?
    public let dataBase64: String?

    enum CodingKeys: String, CodingKey {
        case format
        case databaseId = "database_id"
        case artworkCount = "artwork_count"
        case filePath = "file_path"
        case dataBase64 = "data_base64"
    }

    public init(
        databaseId: Int,
        artworkCount: Int,
        format: String? = nil,
        filePath: String? = nil,
        dataBase64: String? = nil
    ) {
        self.databaseId = databaseId
        self.artworkCount = artworkCount
        self.format = format
        self.filePath = filePath
        self.dataBase64 = dataBase64
    }
}

// MARK: - ConvertResult

public struct ConvertedTrack: Codable, Equatable, Sendable {
    public let sourceDatabaseId: Int
    public let newDatabaseId: Int
    public let newFilePath: String

    enum CodingKeys: String, CodingKey {
        case sourceDatabaseId = "source_database_id"
        case newDatabaseId = "new_database_id"
        case newFilePath = "new_file_path"
    }

    public init(sourceDatabaseId: Int, newDatabaseId: Int, newFilePath: String) {
        self.sourceDatabaseId = sourceDatabaseId
        self.newDatabaseId = newDatabaseId
        self.newFilePath = newFilePath
    }
}

public struct ConvertResult: Codable, Equatable, Sendable {
    public let converted: Bool
    public let tracks: [ConvertedTrack]

    public init(converted: Bool, tracks: [ConvertedTrack]) {
        self.converted = converted
        self.tracks = tracks
    }
}

// MARK: - PlaylistInfoResult

public struct PlaylistInfoResult: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let description: String?
    public let trackCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case trackCount = "track_count"
    }

    public init(id: String, name: String, description: String? = nil, trackCount: Int? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.trackCount = trackCount
    }
}

// MARK: - RatingResult

public struct RatingResult: Codable, Equatable, Sendable {
    public let updated: Bool
    public let id: String
    public let rating: Int?

    public init(updated: Bool, id: String, rating: Int? = nil) {
        self.updated = updated
        self.id = id
        self.rating = rating
    }
}

// MARK: - CreatePlaylistResult

public struct CreatePlaylistResult: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let description: String?

    public init(id: String, name: String, description: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
    }
}

// MARK: - AddToLibraryResult

public struct AddToLibraryResult: Codable, Equatable, Sendable {
    public let added: Bool
    public let ids: [String]
    public let type: String

    public init(added: Bool, ids: [String], type: String) {
        self.added = added
        self.ids = ids
        self.type = type
    }
}

// MARK: - HeavyRotationResult

public struct HeavyRotationItem: Codable, Equatable, Sendable {
    public let type: String
    public let id: String
    public let name: String
    public let artworkUrl: String?

    enum CodingKeys: String, CodingKey {
        case type, id, name
        case artworkUrl = "artwork_url"
    }

    public init(type: String, id: String, name: String, artworkUrl: String? = nil) {
        self.type = type
        self.id = id
        self.name = name
        self.artworkUrl = artworkUrl
    }

    public static func fixture(
        type: String = "album",
        id: String = "hr.1",
        name: String = "Heavy Rotation Album",
        artworkUrl: String? = nil
    ) -> Self {
        .init(type: type, id: id, name: name, artworkUrl: artworkUrl)
    }
}

public struct HeavyRotationResult: Codable, Equatable, Sendable {
    public let items: [HeavyRotationItem]

    public init(items: [HeavyRotationItem]) {
        self.items = items
    }
}

// MARK: - RecentlyAddedResult

public struct RecentlyAddedItem: Codable, Equatable, Sendable {
    public let type: String
    public let id: String
    public let name: String
    public let artworkUrl: String?

    enum CodingKeys: String, CodingKey {
        case type, id, name
        case artworkUrl = "artwork_url"
    }

    public init(type: String, id: String, name: String, artworkUrl: String? = nil) {
        self.type = type
        self.id = id
        self.name = name
        self.artworkUrl = artworkUrl
    }

    public static func fixture(
        type: String = "album",
        id: String = "ra.1",
        name: String = "Recently Added Album",
        artworkUrl: String? = nil
    ) -> Self {
        .init(type: type, id: id, name: name, artworkUrl: artworkUrl)
    }
}

public struct RecentlyAddedResult: Codable, Equatable, Sendable {
    public let items: [RecentlyAddedItem]

    public init(items: [RecentlyAddedItem]) {
        self.items = items
    }
}

// MARK: - MusicSummariesResult

public struct MusicSummaryEntry: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let playCount: Int?
    public let artworkUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case playCount = "play_count"
        case artworkUrl = "artwork_url"
    }

    public init(id: String, name: String, playCount: Int? = nil, artworkUrl: String? = nil) {
        self.id = id
        self.name = name
        self.playCount = playCount
        self.artworkUrl = artworkUrl
    }

    public static func fixture(
        id: String = "ms.1",
        name: String = "Top Song",
        playCount: Int? = 42,
        artworkUrl: String? = nil
    ) -> Self {
        .init(id: id, name: name, playCount: playCount, artworkUrl: artworkUrl)
    }
}

public struct MusicSummariesResult: Codable, Equatable, Sendable {
    public let year: String
    public let period: String?
    public let topArtists: [MusicSummaryEntry]?
    public let topAlbums: [MusicSummaryEntry]?
    public let topSongs: [MusicSummaryEntry]?

    enum CodingKeys: String, CodingKey {
        case year, period
        case topArtists = "top_artists"
        case topAlbums = "top_albums"
        case topSongs = "top_songs"
    }

    public init(
        year: String,
        period: String? = nil,
        topArtists: [MusicSummaryEntry]? = nil,
        topAlbums: [MusicSummaryEntry]? = nil,
        topSongs: [MusicSummaryEntry]? = nil
    ) {
        self.year = year
        self.period = period
        self.topArtists = topArtists
        self.topAlbums = topAlbums
        self.topSongs = topSongs
    }
}

// MARK: - FavoriteResult

public struct FavoriteResult: Codable, Equatable, Sendable {
    public let added: Bool
    public let type: String
    public let id: String

    public init(added: Bool, type: String, id: String) {
        self.added = added
        self.type = type
        self.id = id
    }
}

// MARK: - StationGenresResult

public struct StationGenre: Codable, Equatable, Sendable {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    public static func fixture(
        id: String = "sg.1",
        name: String = "Pop"
    ) -> Self {
        .init(id: id, name: name)
    }
}

public struct StationGenresResult: Codable, Equatable, Sendable {
    public let genres: [StationGenre]

    public init(genres: [StationGenre]) {
        self.genres = genres
    }
}

// MARK: - EquivalentResult

public struct EquivalentResult: Codable, Equatable, Sendable {
    public let type: String
    public let songs: [SongDTO]?
    public let albums: [AlbumDTO]?

    public init(type: String, songs: [SongDTO]? = nil, albums: [AlbumDTO]? = nil) {
        self.type = type
        self.songs = songs
        self.albums = albums
    }
}

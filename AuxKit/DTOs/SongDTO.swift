//
//  SongDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

public struct PlayParameters: Codable, Equatable, Sendable {
    public let id: String
    public let kind: String

    public init(id: String, kind: String) {
        self.id = id
        self.kind = kind
    }
}

public struct SongDTO: Codable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let artistName: String
    public let albumTitle: String?
    public let durationSeconds: Double?
    public let trackNumber: Int?
    public let discNumber: Int?
    public let genreNames: [String]
    public let releaseDate: String?
    public let isrc: String?
    public let hasLyrics: Bool?
    public let artworkUrl: String?
    public let url: String?
    public let previewUrl: String?
    public let contentRating: String?
    public let playCount: Int?
    public let lastPlayedDate: String?
    public let libraryAddedDate: String?
    public let audioVariants: [String]?
    public let isAppleDigitalMaster: Bool?
    public let playParameters: PlayParameters?

    enum CodingKeys: String, CodingKey {
        case id, title, url, isrc
        case artistName = "artist_name"
        case albumTitle = "album_title"
        case durationSeconds = "duration_seconds"
        case trackNumber = "track_number"
        case discNumber = "disc_number"
        case genreNames = "genre_names"
        case releaseDate = "release_date"
        case hasLyrics = "has_lyrics"
        case artworkUrl = "artwork_url"
        case previewUrl = "preview_url"
        case contentRating = "content_rating"
        case playCount = "play_count"
        case lastPlayedDate = "last_played_date"
        case libraryAddedDate = "library_added_date"
        case audioVariants = "audio_variants"
        case isAppleDigitalMaster = "is_apple_digital_master"
        case playParameters = "play_parameters"
    }

    public init(
        id: String,
        title: String,
        artistName: String,
        albumTitle: String? = nil,
        durationSeconds: Double? = nil,
        trackNumber: Int? = nil,
        discNumber: Int? = nil,
        genreNames: [String] = [],
        releaseDate: String? = nil,
        isrc: String? = nil,
        hasLyrics: Bool? = nil,
        artworkUrl: String? = nil,
        url: String? = nil,
        previewUrl: String? = nil,
        contentRating: String? = nil,
        playCount: Int? = nil,
        lastPlayedDate: String? = nil,
        libraryAddedDate: String? = nil,
        audioVariants: [String]? = nil,
        isAppleDigitalMaster: Bool? = nil,
        playParameters: PlayParameters? = nil
    ) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.albumTitle = albumTitle
        self.durationSeconds = durationSeconds
        self.trackNumber = trackNumber
        self.discNumber = discNumber
        self.genreNames = genreNames
        self.releaseDate = releaseDate
        self.isrc = isrc
        self.hasLyrics = hasLyrics
        self.artworkUrl = artworkUrl
        self.url = url
        self.previewUrl = previewUrl
        self.contentRating = contentRating
        self.playCount = playCount
        self.lastPlayedDate = lastPlayedDate
        self.libraryAddedDate = libraryAddedDate
        self.audioVariants = audioVariants
        self.isAppleDigitalMaster = isAppleDigitalMaster
        self.playParameters = playParameters
    }

    public static func fixture(
        id: String = "1",
        title: String = "Test Song",
        artistName: String = "Test Artist",
        albumTitle: String? = nil,
        durationSeconds: Double? = nil,
        trackNumber: Int? = nil,
        discNumber: Int? = nil,
        genreNames: [String] = ["Pop"],
        releaseDate: String? = nil,
        isrc: String? = nil,
        hasLyrics: Bool? = nil,
        artworkUrl: String? = nil,
        url: String? = nil,
        previewUrl: String? = nil,
        contentRating: String? = nil,
        playCount: Int? = nil,
        lastPlayedDate: String? = nil,
        libraryAddedDate: String? = nil,
        audioVariants: [String]? = nil,
        isAppleDigitalMaster: Bool? = nil,
        playParameters: PlayParameters? = nil
    ) -> Self {
        .init(
            id: id,
            title: title,
            artistName: artistName,
            albumTitle: albumTitle,
            durationSeconds: durationSeconds,
            trackNumber: trackNumber,
            discNumber: discNumber,
            genreNames: genreNames,
            releaseDate: releaseDate,
            isrc: isrc,
            hasLyrics: hasLyrics,
            artworkUrl: artworkUrl,
            url: url,
            previewUrl: previewUrl,
            contentRating: contentRating,
            playCount: playCount,
            lastPlayedDate: lastPlayedDate,
            libraryAddedDate: libraryAddedDate,
            audioVariants: audioVariants,
            isAppleDigitalMaster: isAppleDigitalMaster,
            playParameters: playParameters
        )
    }
}

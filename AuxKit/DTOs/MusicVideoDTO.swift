//
//  MusicVideoDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

public struct MusicVideoDTO: Codable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let artistName: String
    public let albumTitle: String?
    public let durationSeconds: Double?
    public let genreNames: [String]
    public let releaseDate: String?
    public let isrc: String?
    public let hasLyrics: Bool?
    public let artworkUrl: String?
    public let url: String?
    public let contentRating: String?

    enum CodingKeys: String, CodingKey {
        case id, title, url, isrc
        case artistName = "artist_name"
        case albumTitle = "album_title"
        case durationSeconds = "duration_seconds"
        case genreNames = "genre_names"
        case releaseDate = "release_date"
        case hasLyrics = "has_lyrics"
        case artworkUrl = "artwork_url"
        case contentRating = "content_rating"
    }

    public init(
        id: String,
        title: String,
        artistName: String,
        albumTitle: String? = nil,
        durationSeconds: Double? = nil,
        genreNames: [String] = [],
        releaseDate: String? = nil,
        isrc: String? = nil,
        hasLyrics: Bool? = nil,
        artworkUrl: String? = nil,
        url: String? = nil,
        contentRating: String? = nil
    ) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.albumTitle = albumTitle
        self.durationSeconds = durationSeconds
        self.genreNames = genreNames
        self.releaseDate = releaseDate
        self.isrc = isrc
        self.hasLyrics = hasLyrics
        self.artworkUrl = artworkUrl
        self.url = url
        self.contentRating = contentRating
    }

    public static func fixture(
        id: String = "mv.1",
        title: String = "Test Music Video",
        artistName: String = "Test Artist",
        albumTitle: String? = nil,
        durationSeconds: Double? = nil,
        genreNames: [String] = ["Pop"],
        releaseDate: String? = nil,
        isrc: String? = nil,
        hasLyrics: Bool? = nil,
        artworkUrl: String? = nil,
        url: String? = nil,
        contentRating: String? = nil
    ) -> Self {
        .init(
            id: id,
            title: title,
            artistName: artistName,
            albumTitle: albumTitle,
            durationSeconds: durationSeconds,
            genreNames: genreNames,
            releaseDate: releaseDate,
            isrc: isrc,
            hasLyrics: hasLyrics,
            artworkUrl: artworkUrl,
            url: url,
            contentRating: contentRating
        )
    }
}

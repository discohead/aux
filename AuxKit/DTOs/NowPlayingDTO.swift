//
//  NowPlayingDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Represents the currently playing track state.
public struct NowPlayingDTO: Codable, Equatable, Sendable {
    public let title: String
    public let artistName: String
    public let albumTitle: String
    public let durationSeconds: Double?
    public let positionSeconds: Double?
    public let state: String
    public let trackNumber: Int?
    public let year: Int?
    public let genre: String?
    public let databaseId: Int?

    enum CodingKeys: String, CodingKey {
        case title, state, year, genre
        case artistName = "artist_name"
        case albumTitle = "album_title"
        case durationSeconds = "duration_seconds"
        case positionSeconds = "position_seconds"
        case trackNumber = "track_number"
        case databaseId = "database_id"
    }

    public init(
        title: String,
        artistName: String,
        albumTitle: String,
        durationSeconds: Double? = nil,
        positionSeconds: Double? = nil,
        state: String,
        trackNumber: Int? = nil,
        year: Int? = nil,
        genre: String? = nil,
        databaseId: Int? = nil
    ) {
        self.title = title
        self.artistName = artistName
        self.albumTitle = albumTitle
        self.durationSeconds = durationSeconds
        self.positionSeconds = positionSeconds
        self.state = state
        self.trackNumber = trackNumber
        self.year = year
        self.genre = genre
        self.databaseId = databaseId
    }

    public static func fixture(
        title: String = "Test Song",
        artistName: String = "Test Artist",
        albumTitle: String = "Test Album",
        durationSeconds: Double? = nil,
        positionSeconds: Double? = nil,
        state: String = "playing",
        trackNumber: Int? = nil,
        year: Int? = nil,
        genre: String? = nil,
        databaseId: Int? = nil
    ) -> NowPlayingDTO {
        NowPlayingDTO(
            title: title,
            artistName: artistName,
            albumTitle: albumTitle,
            durationSeconds: durationSeconds,
            positionSeconds: positionSeconds,
            state: state,
            trackNumber: trackNumber,
            year: year,
            genre: genre,
            databaseId: databaseId
        )
    }
}

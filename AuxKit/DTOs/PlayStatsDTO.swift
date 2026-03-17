//
//  PlayStatsDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Play statistics for a track.
public struct PlayStatsDTO: Codable, Equatable, Sendable {
    public let databaseId: Int
    public let name: String
    public let artist: String?
    public let playedCount: Int?
    public let playedDate: String?
    public let skippedCount: Int?
    public let skippedDate: String?
    public let rating: Int?
    public let loved: Bool?
    public let disliked: Bool?

    enum CodingKeys: String, CodingKey {
        case databaseId = "database_id"
        case name, artist, rating, loved, disliked
        case playedCount = "played_count"
        case playedDate = "played_date"
        case skippedCount = "skipped_count"
        case skippedDate = "skipped_date"
    }

    public init(
        databaseId: Int,
        name: String,
        artist: String? = nil,
        playedCount: Int? = nil,
        playedDate: String? = nil,
        skippedCount: Int? = nil,
        skippedDate: String? = nil,
        rating: Int? = nil,
        loved: Bool? = nil,
        disliked: Bool? = nil
    ) {
        self.databaseId = databaseId
        self.name = name
        self.artist = artist
        self.playedCount = playedCount
        self.playedDate = playedDate
        self.skippedCount = skippedCount
        self.skippedDate = skippedDate
        self.rating = rating
        self.loved = loved
        self.disliked = disliked
    }

    public static func fixture(
        databaseId: Int = 1,
        name: String = "Test Track",
        artist: String? = nil,
        playedCount: Int? = nil,
        playedDate: String? = nil,
        skippedCount: Int? = nil,
        skippedDate: String? = nil,
        rating: Int? = nil,
        loved: Bool? = nil,
        disliked: Bool? = nil
    ) -> PlayStatsDTO {
        PlayStatsDTO(
            databaseId: databaseId,
            name: name,
            artist: artist,
            playedCount: playedCount,
            playedDate: playedDate,
            skippedCount: skippedCount,
            skippedDate: skippedDate,
            rating: rating,
            loved: loved,
            disliked: disliked
        )
    }
}

//
//  TrackTagsDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Full metadata tags for a track.
public struct TrackTagsDTO: Codable, Equatable, Sendable {
    public let databaseId: Int
    public let persistentId: String?
    public let name: String
    public let artist: String?
    public let albumArtist: String?
    public let album: String?
    public let genre: String?
    public let year: Int?
    public let composer: String?
    public let comments: String?
    public let grouping: String?
    public let trackNumber: Int?
    public let trackCount: Int?
    public let discNumber: Int?
    public let discCount: Int?
    public let compilation: Bool?
    public let enabled: Bool?
    public let rating: Int?
    public let loved: Bool?
    public let disliked: Bool?
    public let bpm: Int?
    public let volumeAdjustment: Int?
    public let eq: String?
    public let start: Double?
    public let finish: Double?
    public let sortName: String?
    public let sortArtist: String?
    public let sortAlbumArtist: String?
    public let sortAlbum: String?
    public let sortComposer: String?
    public let lyrics: String?
    public let duration: Double?
    public let time: String?
    public let dateAdded: String?
    public let kind: String?
    public let artworkCount: Int?
    public let playedCount: Int?
    public let playedDate: String?
    public let skippedCount: Int?
    public let skippedDate: String?

    enum CodingKeys: String, CodingKey {
        case databaseId = "database_id"
        case persistentId = "persistent_id"
        case name, artist, album, genre, year, composer, comments, grouping
        case albumArtist = "album_artist"
        case trackNumber = "track_number"
        case trackCount = "track_count"
        case discNumber = "disc_number"
        case discCount = "disc_count"
        case compilation, enabled, rating, loved, disliked, bpm
        case volumeAdjustment = "volume_adjustment"
        case eq, start, finish
        case sortName = "sort_name"
        case sortArtist = "sort_artist"
        case sortAlbumArtist = "sort_album_artist"
        case sortAlbum = "sort_album"
        case sortComposer = "sort_composer"
        case lyrics, duration, time
        case dateAdded = "date_added"
        case kind
        case artworkCount = "artwork_count"
        case playedCount = "played_count"
        case playedDate = "played_date"
        case skippedCount = "skipped_count"
        case skippedDate = "skipped_date"
    }

    public init(
        databaseId: Int,
        persistentId: String? = nil,
        name: String,
        artist: String? = nil,
        albumArtist: String? = nil,
        album: String? = nil,
        genre: String? = nil,
        year: Int? = nil,
        composer: String? = nil,
        comments: String? = nil,
        grouping: String? = nil,
        trackNumber: Int? = nil,
        trackCount: Int? = nil,
        discNumber: Int? = nil,
        discCount: Int? = nil,
        compilation: Bool? = nil,
        enabled: Bool? = nil,
        rating: Int? = nil,
        loved: Bool? = nil,
        disliked: Bool? = nil,
        bpm: Int? = nil,
        volumeAdjustment: Int? = nil,
        eq: String? = nil,
        start: Double? = nil,
        finish: Double? = nil,
        sortName: String? = nil,
        sortArtist: String? = nil,
        sortAlbumArtist: String? = nil,
        sortAlbum: String? = nil,
        sortComposer: String? = nil,
        lyrics: String? = nil,
        duration: Double? = nil,
        time: String? = nil,
        dateAdded: String? = nil,
        kind: String? = nil,
        artworkCount: Int? = nil,
        playedCount: Int? = nil,
        playedDate: String? = nil,
        skippedCount: Int? = nil,
        skippedDate: String? = nil
    ) {
        self.databaseId = databaseId
        self.persistentId = persistentId
        self.name = name
        self.artist = artist
        self.albumArtist = albumArtist
        self.album = album
        self.genre = genre
        self.year = year
        self.composer = composer
        self.comments = comments
        self.grouping = grouping
        self.trackNumber = trackNumber
        self.trackCount = trackCount
        self.discNumber = discNumber
        self.discCount = discCount
        self.compilation = compilation
        self.enabled = enabled
        self.rating = rating
        self.loved = loved
        self.disliked = disliked
        self.bpm = bpm
        self.volumeAdjustment = volumeAdjustment
        self.eq = eq
        self.start = start
        self.finish = finish
        self.sortName = sortName
        self.sortArtist = sortArtist
        self.sortAlbumArtist = sortAlbumArtist
        self.sortAlbum = sortAlbum
        self.sortComposer = sortComposer
        self.lyrics = lyrics
        self.duration = duration
        self.time = time
        self.dateAdded = dateAdded
        self.kind = kind
        self.artworkCount = artworkCount
        self.playedCount = playedCount
        self.playedDate = playedDate
        self.skippedCount = skippedCount
        self.skippedDate = skippedDate
    }

    public static func fixture(
        databaseId: Int = 1,
        persistentId: String? = nil,
        name: String = "Test Track",
        artist: String? = nil,
        albumArtist: String? = nil,
        album: String? = nil,
        genre: String? = nil,
        year: Int? = nil,
        composer: String? = nil,
        comments: String? = nil,
        grouping: String? = nil,
        trackNumber: Int? = nil,
        trackCount: Int? = nil,
        discNumber: Int? = nil,
        discCount: Int? = nil,
        compilation: Bool? = nil,
        enabled: Bool? = nil,
        rating: Int? = nil,
        loved: Bool? = nil,
        disliked: Bool? = nil,
        bpm: Int? = nil,
        volumeAdjustment: Int? = nil,
        eq: String? = nil,
        start: Double? = nil,
        finish: Double? = nil,
        sortName: String? = nil,
        sortArtist: String? = nil,
        sortAlbumArtist: String? = nil,
        sortAlbum: String? = nil,
        sortComposer: String? = nil,
        lyrics: String? = nil,
        duration: Double? = nil,
        time: String? = nil,
        dateAdded: String? = nil,
        kind: String? = nil,
        artworkCount: Int? = nil,
        playedCount: Int? = nil,
        playedDate: String? = nil,
        skippedCount: Int? = nil,
        skippedDate: String? = nil
    ) -> TrackTagsDTO {
        TrackTagsDTO(
            databaseId: databaseId,
            persistentId: persistentId,
            name: name,
            artist: artist,
            albumArtist: albumArtist,
            album: album,
            genre: genre,
            year: year,
            composer: composer,
            comments: comments,
            grouping: grouping,
            trackNumber: trackNumber,
            trackCount: trackCount,
            discNumber: discNumber,
            discCount: discCount,
            compilation: compilation,
            enabled: enabled,
            rating: rating,
            loved: loved,
            disliked: disliked,
            bpm: bpm,
            volumeAdjustment: volumeAdjustment,
            eq: eq,
            start: start,
            finish: finish,
            sortName: sortName,
            sortArtist: sortArtist,
            sortAlbumArtist: sortAlbumArtist,
            sortAlbum: sortAlbum,
            sortComposer: sortComposer,
            lyrics: lyrics,
            duration: duration,
            time: time,
            dateAdded: dateAdded,
            kind: kind,
            artworkCount: artworkCount,
            playedCount: playedCount,
            playedDate: playedDate,
            skippedCount: skippedCount,
            skippedDate: skippedDate
        )
    }
}

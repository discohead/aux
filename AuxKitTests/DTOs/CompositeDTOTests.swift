//
//  CompositeDTOTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

// MARK: - Helpers

private let encoder = JSONEncoder.aux
private let decoder = JSONDecoder.aux

private func roundTrip<T: Codable & Equatable>(_ value: T) throws -> T {
    let data = try encoder.encode(value)
    return try decoder.decode(T.self, from: data)
}

private func jsonString<T: Encodable>(_ value: T) throws -> String {
    let data = try encoder.encode(value)
    return String(data: data, encoding: .utf8)!
}

private func jsonDict<T: Encodable>(_ value: T) throws -> [String: Any] {
    let data = try encoder.encode(value)
    return try JSONSerialization.jsonObject(with: data) as! [String: Any]
}

// MARK: - Fixtures

private func makeSongDTO() -> SongDTO {
    SongDTO.fixture(
        id: "s1",
        title: "Test Song",
        artistName: "Test Artist",
        genreNames: ["Pop"]
    )
}

private func makeMusicVideoDTO() -> MusicVideoDTO {
    MusicVideoDTO.fixture(
        id: "mv1",
        title: "Test MV",
        artistName: "Test Artist",
        genreNames: ["Rock"]
    )
}

// MARK: - TrackDTO Tests

struct TrackDTOTests {

    @Test func songVariantEncodesTypeAsSong() throws {
        let track = TrackDTO.song(makeSongDTO())
        let dict = try jsonDict(track)
        #expect(dict["type"] as? String == "song")
        #expect(dict["song"] != nil)
        #expect(dict["music_video"] == nil)
    }

    @Test func musicVideoVariantEncodesTypeAsMusicVideo() throws {
        let track = TrackDTO.musicVideo(makeMusicVideoDTO())
        let dict = try jsonDict(track)
        #expect(dict["type"] as? String == "music_video")
        #expect(dict["music_video"] != nil)
        #expect(dict["song"] == nil)
    }

    @Test func roundTripsViaJSON() throws {
        let songTrack = TrackDTO.song(makeSongDTO())
        let decoded = try roundTrip(songTrack)
        #expect(decoded == songTrack)

        let mvTrack = TrackDTO.musicVideo(makeMusicVideoDTO())
        let decodedMV = try roundTrip(mvTrack)
        #expect(decodedMV == mvTrack)
    }
}

// MARK: - ChartDTO Tests

struct ChartDTOTests {

    @Test func roundTripsViaJSON() throws {
        let chart = ChartDTO<SongDTO>(
            title: "Top Songs",
            kind: "mostPlayed",
            items: [makeSongDTO()],
            hasNext: true
        )
        let decoded = try roundTrip(chart)
        #expect(decoded == chart)
        #expect(decoded.items.count == 1)
        #expect(decoded.hasNext == true)
    }

    @Test func usesSnakeCaseKeys() throws {
        let chart = ChartDTO<SongDTO>(
            title: "Daily Top 100",
            kind: "dailyGlobalTop",
            items: [],
            hasNext: false
        )
        let str = try jsonString(chart)
        #expect(str.contains("has_next"))
        #expect(!str.contains("hasNext"))
    }
}

// MARK: - TopResultDTO Tests

struct TopResultDTOTests {

    @Test func roundTripsViaJSON() throws {
        let result = TopResultDTO(type: "song", id: "12345", title: "Test Song")
        let decoded = try roundTrip(result)
        #expect(decoded == result)
        #expect(decoded.type == "song")
        #expect(decoded.id == "12345")
        #expect(decoded.title == "Test Song")
    }
}

// MARK: - NowPlayingDTO Tests

struct NowPlayingDTOTests {

    @Test func roundTripsViaJSON() throws {
        let np = NowPlayingDTO(
            title: "Bohemian Rhapsody",
            artistName: "Queen",
            albumTitle: "A Night at the Opera",
            durationSeconds: 354.0,
            positionSeconds: 120.5,
            state: "playing",
            trackNumber: 11,
            year: 1975,
            genre: "Rock",
            databaseId: 42
        )
        let decoded = try roundTrip(np)
        #expect(decoded == np)
        #expect(decoded.durationSeconds == 354.0)
        #expect(decoded.positionSeconds == 120.5)
        #expect(decoded.trackNumber == 11)
        #expect(decoded.databaseId == 42)
    }

    @Test func usesSnakeCaseKeys() throws {
        let np = NowPlayingDTO(
            title: "Test",
            artistName: "Artist",
            albumTitle: "Album",
            durationSeconds: nil,
            positionSeconds: nil,
            state: "paused",
            trackNumber: nil,
            year: nil,
            genre: nil,
            databaseId: nil
        )
        let str = try jsonString(np)
        #expect(str.contains("artist_name"))
        #expect(!str.contains("artistName"))
        #expect(str.contains("album_title"))
        #expect(!str.contains("albumTitle"))
        #expect(str.contains("\"state\""))
    }
}

// MARK: - TrackTagsDTO Tests

struct TrackTagsDTOTests {

    private func makeTrackTags() -> TrackTagsDTO {
        TrackTagsDTO(
            databaseId: 1001,
            persistentId: "ABCDEF1234567890",
            name: "Test Track",
            artist: "Test Artist",
            albumArtist: "Test Album Artist",
            album: "Test Album",
            genre: "Rock",
            year: 2024,
            composer: "Test Composer",
            comments: "A comment",
            grouping: "Group A",
            trackNumber: 3,
            trackCount: 12,
            discNumber: 1,
            discCount: 2,
            compilation: false,
            enabled: true,
            rating: 80,
            loved: true,
            disliked: false,
            bpm: 120,
            volumeAdjustment: 10,
            eq: "Rock",
            start: 0.5,
            finish: 300.0,
            sortName: "test track",
            sortArtist: "test artist",
            sortAlbumArtist: "test album artist",
            sortAlbum: "test album",
            sortComposer: "test composer",
            lyrics: "La la la",
            duration: 305.2,
            time: "5:05",
            dateAdded: "2024-01-15T10:30:00Z",
            kind: "MPEG audio file",
            artworkCount: 1,
            playedCount: 42,
            playedDate: "2024-03-10T08:00:00Z",
            skippedCount: 3,
            skippedDate: "2024-03-09T12:00:00Z"
        )
    }

    @Test func roundTripsViaJSON() throws {
        let tags = makeTrackTags()
        let decoded = try roundTrip(tags)
        #expect(decoded == tags)
        #expect(decoded.databaseId == 1001)
        #expect(decoded.name == "Test Track")
        #expect(decoded.bpm == 120)
        #expect(decoded.lyrics == "La la la")
    }

    @Test func allWritableFieldsArePresent() throws {
        let tags = makeTrackTags()
        let str = try jsonString(tags)
        // Identity fields
        #expect(str.contains("database_id"))
        #expect(str.contains("persistent_id"))
        // Core tags
        #expect(str.contains("\"name\""))
        #expect(str.contains("\"artist\""))
        #expect(str.contains("album_artist"))
        #expect(str.contains("\"album\""))
        #expect(str.contains("\"genre\""))
        #expect(str.contains("\"year\""))
        #expect(str.contains("\"composer\""))
        #expect(str.contains("\"comments\""))
        #expect(str.contains("\"grouping\""))
        // Disc/Track numbering
        #expect(str.contains("track_number"))
        #expect(str.contains("track_count"))
        #expect(str.contains("disc_number"))
        #expect(str.contains("disc_count"))
        // Flags and ratings
        #expect(str.contains("\"compilation\""))
        #expect(str.contains("\"enabled\""))
        #expect(str.contains("\"rating\""))
        #expect(str.contains("\"loved\""))
        #expect(str.contains("\"disliked\""))
        // Audio properties
        #expect(str.contains("\"bpm\""))
        #expect(str.contains("volume_adjustment"))
        #expect(str.contains("\"eq\""))
        #expect(str.contains("\"start\""))
        #expect(str.contains("\"finish\""))
        // Sort overrides
        #expect(str.contains("sort_name"))
        #expect(str.contains("sort_artist"))
        #expect(str.contains("sort_album_artist"))
        #expect(str.contains("sort_album"))
        #expect(str.contains("sort_composer"))
        // Lyrics
        #expect(str.contains("\"lyrics\""))
        // Read-only metadata
        #expect(str.contains("\"duration\""))
        #expect(str.contains("\"time\""))
        #expect(str.contains("date_added"))
        #expect(str.contains("\"kind\""))
        #expect(str.contains("artwork_count"))
        // Play statistics
        #expect(str.contains("played_count"))
        #expect(str.contains("played_date"))
        #expect(str.contains("skipped_count"))
        #expect(str.contains("skipped_date"))
        // Verify snake_case (no camelCase leaks)
        #expect(!str.contains("databaseId"))
        #expect(!str.contains("persistentId"))
        #expect(!str.contains("albumArtist"))
        #expect(!str.contains("trackNumber"))
        #expect(!str.contains("trackCount"))
        #expect(!str.contains("discNumber"))
        #expect(!str.contains("discCount"))
        #expect(!str.contains("volumeAdjustment"))
        #expect(!str.contains("sortName"))
        #expect(!str.contains("sortArtist"))
        #expect(!str.contains("sortAlbumArtist"))
        #expect(!str.contains("sortAlbum"))
        #expect(!str.contains("sortComposer"))
        #expect(!str.contains("dateAdded"))
        #expect(!str.contains("artworkCount"))
        #expect(!str.contains("playedCount"))
        #expect(!str.contains("playedDate"))
        #expect(!str.contains("skippedCount"))
        #expect(!str.contains("skippedDate"))
    }
}

// MARK: - FileInfoDTO Tests

struct FileInfoDTOTests {

    @Test func roundTripsViaJSON() throws {
        let info = FileInfoDTO(
            databaseId: 2001,
            location: "/Users/test/Music/song.mp3",
            bitRate: 320,
            sampleRate: 44100,
            size: 8_500_000,
            kind: "MPEG audio file",
            duration: 245.8,
            dateAdded: "2024-01-15T10:30:00Z",
            dateModified: "2024-02-20T14:00:00Z",
            cloudStatus: "matched"
        )
        let decoded = try roundTrip(info)
        #expect(decoded == info)
        #expect(decoded.databaseId == 2001)
        #expect(decoded.location == "/Users/test/Music/song.mp3")
        #expect(decoded.bitRate == 320)
        #expect(decoded.sampleRate == 44100)
        #expect(decoded.size == 8_500_000)

        // Verify snake_case keys
        let str = try jsonString(info)
        #expect(str.contains("database_id"))
        #expect(str.contains("bit_rate"))
        #expect(str.contains("sample_rate"))
        #expect(str.contains("date_added"))
        #expect(str.contains("date_modified"))
        #expect(str.contains("cloud_status"))
        #expect(!str.contains("databaseId"))
        #expect(!str.contains("bitRate"))
        #expect(!str.contains("sampleRate"))
        #expect(!str.contains("dateAdded"))
        #expect(!str.contains("dateModified"))
        #expect(!str.contains("cloudStatus"))
    }
}

// MARK: - PlayStatsDTO Tests

struct PlayStatsDTOTests {

    @Test func roundTripsViaJSON() throws {
        let stats = PlayStatsDTO(
            databaseId: 3001,
            name: "Stats Track",
            artist: "Stats Artist",
            playedCount: 100,
            playedDate: "2024-03-10T08:00:00Z",
            skippedCount: 5,
            skippedDate: "2024-03-09T12:00:00Z",
            rating: 60,
            loved: true,
            disliked: false
        )
        let decoded = try roundTrip(stats)
        #expect(decoded == stats)
        #expect(decoded.databaseId == 3001)
        #expect(decoded.name == "Stats Track")
        #expect(decoded.playedCount == 100)
        #expect(decoded.loved == true)

        // Verify snake_case keys
        let str = try jsonString(stats)
        #expect(str.contains("database_id"))
        #expect(str.contains("played_count"))
        #expect(str.contains("played_date"))
        #expect(str.contains("skipped_count"))
        #expect(str.contains("skipped_date"))
        #expect(!str.contains("databaseId"))
        #expect(!str.contains("playedCount"))
        #expect(!str.contains("playedDate"))
        #expect(!str.contains("skippedCount"))
        #expect(!str.contains("skippedDate"))
    }
}

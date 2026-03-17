//
//  CoreDTOTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

// MARK: - SongDTO Tests

struct SongDTOTests {

    private func makeFullSong() -> SongDTO {
        SongDTO(
            id: "song-001",
            title: "Bohemian Rhapsody",
            artistName: "Queen",
            albumTitle: "A Night at the Opera",
            durationSeconds: 354.0,
            trackNumber: 11,
            discNumber: 1,
            genreNames: ["Rock", "Classic Rock"],
            releaseDate: "1975-10-31",
            isrc: "GBUM71029604",
            hasLyrics: true,
            artworkUrl: "https://example.com/artwork.jpg",
            url: "https://music.apple.com/us/album/bohemian-rhapsody/1440806041?i=1440806768",
            previewUrl: "https://example.com/preview.m4a",
            contentRating: "clean",
            playCount: 42,
            lastPlayedDate: "2026-03-15T10:30:00Z",
            libraryAddedDate: "2025-01-01T00:00:00Z",
            audioVariants: ["lossless", "hi-res-lossless"],
            isAppleDigitalMaster: true,
            playParameters: PlayParameters(id: "song-001", kind: "song")
        )
    }

    @Test func roundTripsViaJSON() throws {
        let original = makeFullSong()
        let data = try JSONEncoder.aux.encode(original)
        let decoded = try JSONDecoder.aux.decode(SongDTO.self, from: data)
        #expect(decoded == original)
        #expect(decoded.id == "song-001")
        #expect(decoded.title == "Bohemian Rhapsody")
        #expect(decoded.artistName == "Queen")
        #expect(decoded.albumTitle == "A Night at the Opera")
        #expect(decoded.durationSeconds == 354.0)
        #expect(decoded.trackNumber == 11)
        #expect(decoded.discNumber == 1)
        #expect(decoded.genreNames == ["Rock", "Classic Rock"])
        #expect(decoded.releaseDate == "1975-10-31")
        #expect(decoded.isrc == "GBUM71029604")
        #expect(decoded.hasLyrics == true)
        #expect(decoded.artworkUrl == "https://example.com/artwork.jpg")
        #expect(decoded.url == "https://music.apple.com/us/album/bohemian-rhapsody/1440806041?i=1440806768")
        #expect(decoded.previewUrl == "https://example.com/preview.m4a")
        #expect(decoded.contentRating == "clean")
        #expect(decoded.playCount == 42)
        #expect(decoded.lastPlayedDate == "2026-03-15T10:30:00Z")
        #expect(decoded.libraryAddedDate == "2025-01-01T00:00:00Z")
        #expect(decoded.audioVariants == ["lossless", "hi-res-lossless"])
        #expect(decoded.isAppleDigitalMaster == true)
        #expect(decoded.playParameters?.id == "song-001")
        #expect(decoded.playParameters?.kind == "song")
    }

    @Test func usesSnakeCaseJSONKeys() throws {
        let song = makeFullSong()
        let data = try JSONEncoder.aux.encode(song)
        let json = String(data: data, encoding: .utf8)!

        // snake_case keys must be present
        #expect(json.contains("\"artist_name\""))
        #expect(json.contains("\"album_title\""))
        #expect(json.contains("\"duration_seconds\""))
        #expect(json.contains("\"track_number\""))
        #expect(json.contains("\"disc_number\""))
        #expect(json.contains("\"genre_names\""))
        #expect(json.contains("\"release_date\""))
        #expect(json.contains("\"has_lyrics\""))
        #expect(json.contains("\"artwork_url\""))
        #expect(json.contains("\"preview_url\""))
        #expect(json.contains("\"content_rating\""))
        #expect(json.contains("\"play_count\""))
        #expect(json.contains("\"last_played_date\""))
        #expect(json.contains("\"library_added_date\""))
        #expect(json.contains("\"audio_variants\""))
        #expect(json.contains("\"is_apple_digital_master\""))
        #expect(json.contains("\"play_parameters\""))

        // camelCase keys must NOT be present
        #expect(!json.contains("\"artistName\""))
        #expect(!json.contains("\"albumTitle\""))
        #expect(!json.contains("\"durationSeconds\""))
        #expect(!json.contains("\"trackNumber\""))
        #expect(!json.contains("\"discNumber\""))
        #expect(!json.contains("\"genreNames\""))
        #expect(!json.contains("\"releaseDate\""))
        #expect(!json.contains("\"hasLyrics\""))
        #expect(!json.contains("\"artworkUrl\""))
        #expect(!json.contains("\"previewUrl\""))
        #expect(!json.contains("\"contentRating\""))
        #expect(!json.contains("\"playCount\""))
        #expect(!json.contains("\"lastPlayedDate\""))
        #expect(!json.contains("\"libraryAddedDate\""))
        #expect(!json.contains("\"audioVariants\""))
        #expect(!json.contains("\"isAppleDigitalMaster\""))
        #expect(!json.contains("\"playParameters\""))
    }

    @Test func nullableFieldsOmittedWhenNil() throws {
        let song = SongDTO(
            id: "song-minimal",
            title: "Minimal Song",
            artistName: "Unknown",
            albumTitle: nil,
            durationSeconds: nil,
            trackNumber: nil,
            discNumber: nil,
            genreNames: [],
            releaseDate: nil,
            isrc: nil,
            hasLyrics: nil,
            artworkUrl: nil,
            url: nil,
            previewUrl: nil,
            contentRating: nil,
            playCount: nil,
            lastPlayedDate: nil,
            libraryAddedDate: nil,
            audioVariants: nil,
            isAppleDigitalMaster: nil,
            playParameters: nil
        )
        let data = try JSONEncoder.aux.encode(song)
        let json = String(data: data, encoding: .utf8)!

        // Required fields must be present
        #expect(json.contains("\"id\""))
        #expect(json.contains("\"title\""))
        #expect(json.contains("\"artist_name\""))
        #expect(json.contains("\"genre_names\""))

        // Nil optional fields must be omitted
        #expect(!json.contains("\"album_title\""))
        #expect(!json.contains("\"duration_seconds\""))
        #expect(!json.contains("\"track_number\""))
        #expect(!json.contains("\"disc_number\""))
        #expect(!json.contains("\"release_date\""))
        #expect(!json.contains("\"isrc\""))
        #expect(!json.contains("\"has_lyrics\""))
        #expect(!json.contains("\"artwork_url\""))
        #expect(!json.contains("\"url\""))
        #expect(!json.contains("\"preview_url\""))
        #expect(!json.contains("\"content_rating\""))
        #expect(!json.contains("\"play_count\""))
        #expect(!json.contains("\"last_played_date\""))
        #expect(!json.contains("\"library_added_date\""))
        #expect(!json.contains("\"audio_variants\""))
        #expect(!json.contains("\"is_apple_digital_master\""))
        #expect(!json.contains("\"play_parameters\""))
    }
}

// MARK: - AlbumDTO Tests

struct AlbumDTOTests {

    private func makeFullAlbum(withTracks: Bool = false) -> AlbumDTO {
        let tracks: [SongDTO]? = withTracks ? [
            SongDTO(
                id: "track-1",
                title: "Track One",
                artistName: "Artist",
                albumTitle: "Test Album",
                durationSeconds: 200.0,
                trackNumber: 1,
                discNumber: 1,
                genreNames: ["Pop"],
                releaseDate: nil,
                isrc: nil,
                hasLyrics: nil,
                artworkUrl: nil,
                url: nil,
                previewUrl: nil,
                contentRating: nil,
                playCount: nil,
                lastPlayedDate: nil,
                libraryAddedDate: nil,
                audioVariants: nil,
                isAppleDigitalMaster: nil,
                playParameters: nil
            ),
            SongDTO(
                id: "track-2",
                title: "Track Two",
                artistName: "Artist",
                albumTitle: "Test Album",
                durationSeconds: 180.0,
                trackNumber: 2,
                discNumber: 1,
                genreNames: ["Pop"],
                releaseDate: nil,
                isrc: nil,
                hasLyrics: nil,
                artworkUrl: nil,
                url: nil,
                previewUrl: nil,
                contentRating: nil,
                playCount: nil,
                lastPlayedDate: nil,
                libraryAddedDate: nil,
                audioVariants: nil,
                isAppleDigitalMaster: nil,
                playParameters: nil
            ),
        ] : nil

        return AlbumDTO(
            id: "album-001",
            title: "A Night at the Opera",
            artistName: "Queen",
            trackCount: 12,
            genreNames: ["Rock", "Classic Rock"],
            releaseDate: "1975-11-21",
            upc: "0720642442524",
            isCompilation: false,
            isComplete: true,
            isSingle: false,
            contentRating: "clean",
            artworkUrl: "https://example.com/album-art.jpg",
            url: "https://music.apple.com/us/album/a-night-at-the-opera/1440806041",
            editorialNotes: EditorialNotes(standard: "A landmark album.", short: "Legendary."),
            recordLabelName: "EMI",
            audioVariants: ["lossless"],
            isAppleDigitalMaster: true,
            tracks: tracks
        )
    }

    @Test func roundTripsViaJSON() throws {
        let original = makeFullAlbum()
        let data = try JSONEncoder.aux.encode(original)
        let decoded = try JSONDecoder.aux.decode(AlbumDTO.self, from: data)
        #expect(decoded == original)
        #expect(decoded.id == "album-001")
        #expect(decoded.title == "A Night at the Opera")
        #expect(decoded.artistName == "Queen")
        #expect(decoded.trackCount == 12)
        #expect(decoded.genreNames == ["Rock", "Classic Rock"])
        #expect(decoded.releaseDate == "1975-11-21")
        #expect(decoded.upc == "0720642442524")
        #expect(decoded.isCompilation == false)
        #expect(decoded.isComplete == true)
        #expect(decoded.isSingle == false)
        #expect(decoded.contentRating == "clean")
        #expect(decoded.artworkUrl == "https://example.com/album-art.jpg")
        #expect(decoded.url == "https://music.apple.com/us/album/a-night-at-the-opera/1440806041")
        #expect(decoded.editorialNotes?.standard == "A landmark album.")
        #expect(decoded.editorialNotes?.short == "Legendary.")
        #expect(decoded.recordLabelName == "EMI")
        #expect(decoded.audioVariants == ["lossless"])
        #expect(decoded.isAppleDigitalMaster == true)
        #expect(decoded.tracks == nil)
    }

    @Test func usesSnakeCaseJSONKeys() throws {
        let album = makeFullAlbum()
        let data = try JSONEncoder.aux.encode(album)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"artist_name\""))
        #expect(json.contains("\"track_count\""))
        #expect(json.contains("\"genre_names\""))
        #expect(json.contains("\"release_date\""))
        #expect(json.contains("\"is_compilation\""))
        #expect(json.contains("\"is_complete\""))
        #expect(json.contains("\"is_single\""))
        #expect(json.contains("\"content_rating\""))
        #expect(json.contains("\"artwork_url\""))
        #expect(json.contains("\"editorial_notes\""))
        #expect(json.contains("\"record_label_name\""))
        #expect(json.contains("\"audio_variants\""))
        #expect(json.contains("\"is_apple_digital_master\""))

        #expect(!json.contains("\"artistName\""))
        #expect(!json.contains("\"trackCount\""))
        #expect(!json.contains("\"genreNames\""))
        #expect(!json.contains("\"releaseDate\""))
        #expect(!json.contains("\"isCompilation\""))
        #expect(!json.contains("\"isComplete\""))
        #expect(!json.contains("\"isSingle\""))
        #expect(!json.contains("\"contentRating\""))
        #expect(!json.contains("\"artworkUrl\""))
        #expect(!json.contains("\"editorialNotes\""))
        #expect(!json.contains("\"recordLabelName\""))
        #expect(!json.contains("\"audioVariants\""))
        #expect(!json.contains("\"isAppleDigitalMaster\""))
    }

    @Test func nullableFieldsOmittedWhenNil() throws {
        let album = AlbumDTO(
            id: "album-minimal",
            title: "Minimal Album",
            artistName: "Unknown",
            trackCount: nil,
            genreNames: [],
            releaseDate: nil,
            upc: nil,
            isCompilation: nil,
            isComplete: nil,
            isSingle: nil,
            contentRating: nil,
            artworkUrl: nil,
            url: nil,
            editorialNotes: nil,
            recordLabelName: nil,
            audioVariants: nil,
            isAppleDigitalMaster: nil,
            tracks: nil
        )
        let data = try JSONEncoder.aux.encode(album)
        let json = String(data: data, encoding: .utf8)!

        // Required fields present
        #expect(json.contains("\"id\""))
        #expect(json.contains("\"title\""))
        #expect(json.contains("\"artist_name\""))
        #expect(json.contains("\"genre_names\""))

        // Nil fields omitted
        #expect(!json.contains("\"track_count\""))
        #expect(!json.contains("\"release_date\""))
        #expect(!json.contains("\"upc\""))
        #expect(!json.contains("\"is_compilation\""))
        #expect(!json.contains("\"is_complete\""))
        #expect(!json.contains("\"is_single\""))
        #expect(!json.contains("\"content_rating\""))
        #expect(!json.contains("\"artwork_url\""))
        #expect(!json.contains("\"url\""))
        #expect(!json.contains("\"editorial_notes\""))
        #expect(!json.contains("\"record_label_name\""))
        #expect(!json.contains("\"audio_variants\""))
        #expect(!json.contains("\"is_apple_digital_master\""))
        #expect(!json.contains("\"tracks\""))
    }

    @Test func tracksFieldContainsSongDTOs() throws {
        let album = makeFullAlbum(withTracks: true)
        let data = try JSONEncoder.aux.encode(album)
        let decoded = try JSONDecoder.aux.decode(AlbumDTO.self, from: data)

        #expect(decoded.tracks != nil)
        #expect(decoded.tracks?.count == 2)
        #expect(decoded.tracks?[0].id == "track-1")
        #expect(decoded.tracks?[0].title == "Track One")
        #expect(decoded.tracks?[0].trackNumber == 1)
        #expect(decoded.tracks?[1].id == "track-2")
        #expect(decoded.tracks?[1].title == "Track Two")
        #expect(decoded.tracks?[1].trackNumber == 2)

        // Verify tracks key appears in JSON
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("\"tracks\""))
    }
}

// MARK: - ArtistDTO Tests

struct ArtistDTOTests {

    private func makeFullArtist() -> ArtistDTO {
        ArtistDTO(
            id: "artist-001",
            name: "Queen",
            genreNames: ["Rock", "Classic Rock"],
            artworkUrl: "https://example.com/queen.jpg",
            url: "https://music.apple.com/us/artist/queen/3296",
            editorialNotes: EditorialNotes(standard: "One of the greatest rock bands.", short: "Legendary rock."),
            topSongs: [
                SongDTO(
                    id: "song-top-1",
                    title: "Bohemian Rhapsody",
                    artistName: "Queen",
                    albumTitle: nil,
                    durationSeconds: 354.0,
                    trackNumber: nil,
                    discNumber: nil,
                    genreNames: ["Rock"],
                    releaseDate: nil,
                    isrc: nil,
                    hasLyrics: nil,
                    artworkUrl: nil,
                    url: nil,
                    previewUrl: nil,
                    contentRating: nil,
                    playCount: nil,
                    lastPlayedDate: nil,
                    libraryAddedDate: nil,
                    audioVariants: nil,
                    isAppleDigitalMaster: nil,
                    playParameters: nil
                )
            ],
            albums: [
                AlbumDTO(
                    id: "album-nested-1",
                    title: "A Night at the Opera",
                    artistName: "Queen",
                    trackCount: 12,
                    genreNames: ["Rock"],
                    releaseDate: nil,
                    upc: nil,
                    isCompilation: nil,
                    isComplete: nil,
                    isSingle: nil,
                    contentRating: nil,
                    artworkUrl: nil,
                    url: nil,
                    editorialNotes: nil,
                    recordLabelName: nil,
                    audioVariants: nil,
                    isAppleDigitalMaster: nil,
                    tracks: nil
                )
            ]
        )
    }

    @Test func roundTripsViaJSON() throws {
        let original = makeFullArtist()
        let data = try JSONEncoder.aux.encode(original)
        let decoded = try JSONDecoder.aux.decode(ArtistDTO.self, from: data)
        #expect(decoded == original)
        #expect(decoded.id == "artist-001")
        #expect(decoded.name == "Queen")
        #expect(decoded.genreNames == ["Rock", "Classic Rock"])
        #expect(decoded.artworkUrl == "https://example.com/queen.jpg")
        #expect(decoded.url == "https://music.apple.com/us/artist/queen/3296")
        #expect(decoded.editorialNotes?.standard == "One of the greatest rock bands.")
        #expect(decoded.editorialNotes?.short == "Legendary rock.")
        #expect(decoded.topSongs?.count == 1)
        #expect(decoded.topSongs?[0].title == "Bohemian Rhapsody")
        #expect(decoded.albums?.count == 1)
        #expect(decoded.albums?[0].title == "A Night at the Opera")
    }

    @Test func usesSnakeCaseJSONKeys() throws {
        let artist = makeFullArtist()
        let data = try JSONEncoder.aux.encode(artist)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"genre_names\""))
        #expect(json.contains("\"artwork_url\""))
        #expect(json.contains("\"editorial_notes\""))
        #expect(json.contains("\"top_songs\""))

        #expect(!json.contains("\"genreNames\""))
        #expect(!json.contains("\"artworkUrl\""))
        #expect(!json.contains("\"editorialNotes\""))
        #expect(!json.contains("\"topSongs\""))
    }

    @Test func nullableFieldsOmittedWhenNil() throws {
        let artist = ArtistDTO(
            id: "artist-minimal",
            name: "Unknown Artist",
            genreNames: nil,
            artworkUrl: nil,
            url: nil,
            editorialNotes: nil,
            topSongs: nil,
            albums: nil
        )
        let data = try JSONEncoder.aux.encode(artist)
        let json = String(data: data, encoding: .utf8)!

        // Required fields present
        #expect(json.contains("\"id\""))
        #expect(json.contains("\"name\""))

        // Nil fields omitted
        #expect(!json.contains("\"genre_names\""))
        #expect(!json.contains("\"artwork_url\""))
        #expect(!json.contains("\"url\""))
        #expect(!json.contains("\"editorial_notes\""))
        #expect(!json.contains("\"top_songs\""))
        #expect(!json.contains("\"albums\""))
    }
}

// MARK: - PlaylistDTO Tests

struct PlaylistDTOTests {

    private func makeFullPlaylist() -> PlaylistDTO {
        PlaylistDTO(
            id: "pl-001",
            name: "Today's Hits",
            curatorName: "Apple Music",
            description: "The biggest songs right now.",
            shortDescription: "Today's top tracks.",
            kind: "editorial",
            lastModifiedDate: "2026-03-15T00:00:00Z",
            artworkUrl: "https://example.com/playlist.jpg",
            url: "https://music.apple.com/us/playlist/todays-hits/pl.f4d106fed2bd41149aaacabb233eb5eb",
            isChart: true,
            hasCollaboration: false,
            tracks: [
                TrackDTO(
                    type: "song",
                    song: SongDTO(
                        id: "song-in-pl",
                        title: "Playlist Song",
                        artistName: "Playlist Artist",
                        albumTitle: nil,
                        durationSeconds: 210.0,
                        trackNumber: nil,
                        discNumber: nil,
                        genreNames: ["Pop"],
                        releaseDate: nil,
                        isrc: nil,
                        hasLyrics: nil,
                        artworkUrl: nil,
                        url: nil,
                        previewUrl: nil,
                        contentRating: nil,
                        playCount: nil,
                        lastPlayedDate: nil,
                        libraryAddedDate: nil,
                        audioVariants: nil,
                        isAppleDigitalMaster: nil,
                        playParameters: nil
                    ),
                    musicVideo: nil
                )
            ]
        )
    }

    @Test func roundTripsViaJSON() throws {
        let original = makeFullPlaylist()
        let data = try JSONEncoder.aux.encode(original)
        let decoded = try JSONDecoder.aux.decode(PlaylistDTO.self, from: data)
        #expect(decoded == original)
        #expect(decoded.id == "pl-001")
        #expect(decoded.name == "Today's Hits")
        #expect(decoded.curatorName == "Apple Music")
        #expect(decoded.description == "The biggest songs right now.")
        #expect(decoded.shortDescription == "Today's top tracks.")
        #expect(decoded.kind == "editorial")
        #expect(decoded.lastModifiedDate == "2026-03-15T00:00:00Z")
        #expect(decoded.artworkUrl == "https://example.com/playlist.jpg")
        #expect(decoded.url == "https://music.apple.com/us/playlist/todays-hits/pl.f4d106fed2bd41149aaacabb233eb5eb")
        #expect(decoded.isChart == true)
        #expect(decoded.hasCollaboration == false)
        #expect(decoded.tracks?.count == 1)
        #expect(decoded.tracks?[0].type == "song")
        #expect(decoded.tracks?[0].song?.title == "Playlist Song")
    }

    @Test func usesSnakeCaseJSONKeys() throws {
        let playlist = makeFullPlaylist()
        let data = try JSONEncoder.aux.encode(playlist)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"curator_name\""))
        #expect(json.contains("\"short_description\""))
        #expect(json.contains("\"last_modified_date\""))
        #expect(json.contains("\"artwork_url\""))
        #expect(json.contains("\"is_chart\""))
        #expect(json.contains("\"has_collaboration\""))

        #expect(!json.contains("\"curatorName\""))
        #expect(!json.contains("\"shortDescription\""))
        #expect(!json.contains("\"lastModifiedDate\""))
        #expect(!json.contains("\"artworkUrl\""))
        #expect(!json.contains("\"isChart\""))
        #expect(!json.contains("\"hasCollaboration\""))
    }

    @Test func nullableFieldsOmittedWhenNil() throws {
        let playlist = PlaylistDTO(
            id: "pl-minimal",
            name: "Empty Playlist",
            curatorName: nil,
            description: nil,
            shortDescription: nil,
            kind: nil,
            lastModifiedDate: nil,
            artworkUrl: nil,
            url: nil,
            isChart: nil,
            hasCollaboration: nil,
            tracks: nil
        )
        let data = try JSONEncoder.aux.encode(playlist)
        let json = String(data: data, encoding: .utf8)!

        // Required fields present
        #expect(json.contains("\"id\""))
        #expect(json.contains("\"name\""))

        // Nil fields omitted
        #expect(!json.contains("\"curator_name\""))
        #expect(!json.contains("\"description\""))
        #expect(!json.contains("\"short_description\""))
        #expect(!json.contains("\"kind\""))
        #expect(!json.contains("\"last_modified_date\""))
        #expect(!json.contains("\"artwork_url\""))
        #expect(!json.contains("\"url\""))
        #expect(!json.contains("\"is_chart\""))
        #expect(!json.contains("\"has_collaboration\""))
        #expect(!json.contains("\"tracks\""))
    }
}

// MARK: - MusicVideoDTO Tests

struct MusicVideoDTOTests {

    private func makeFullMusicVideo() -> MusicVideoDTO {
        MusicVideoDTO(
            id: "mv-001",
            title: "Bohemian Rhapsody (Official Video)",
            artistName: "Queen",
            albumTitle: "Greatest Hits",
            durationSeconds: 359.0,
            genreNames: ["Rock", "Music Video"],
            releaseDate: "1975-11-21",
            isrc: "GBUM71029605",
            hasLyrics: true,
            artworkUrl: "https://example.com/mv-art.jpg",
            url: "https://music.apple.com/us/music-video/bohemian-rhapsody/123456",
            contentRating: "clean"
        )
    }

    @Test func roundTripsViaJSON() throws {
        let original = makeFullMusicVideo()
        let data = try JSONEncoder.aux.encode(original)
        let decoded = try JSONDecoder.aux.decode(MusicVideoDTO.self, from: data)
        #expect(decoded == original)
        #expect(decoded.id == "mv-001")
        #expect(decoded.title == "Bohemian Rhapsody (Official Video)")
        #expect(decoded.artistName == "Queen")
        #expect(decoded.albumTitle == "Greatest Hits")
        #expect(decoded.durationSeconds == 359.0)
        #expect(decoded.genreNames == ["Rock", "Music Video"])
        #expect(decoded.releaseDate == "1975-11-21")
        #expect(decoded.isrc == "GBUM71029605")
        #expect(decoded.hasLyrics == true)
        #expect(decoded.artworkUrl == "https://example.com/mv-art.jpg")
        #expect(decoded.url == "https://music.apple.com/us/music-video/bohemian-rhapsody/123456")
        #expect(decoded.contentRating == "clean")
    }

    @Test func usesSnakeCaseJSONKeys() throws {
        let mv = makeFullMusicVideo()
        let data = try JSONEncoder.aux.encode(mv)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"artist_name\""))
        #expect(json.contains("\"album_title\""))
        #expect(json.contains("\"duration_seconds\""))
        #expect(json.contains("\"genre_names\""))
        #expect(json.contains("\"release_date\""))
        #expect(json.contains("\"has_lyrics\""))
        #expect(json.contains("\"artwork_url\""))
        #expect(json.contains("\"content_rating\""))

        #expect(!json.contains("\"artistName\""))
        #expect(!json.contains("\"albumTitle\""))
        #expect(!json.contains("\"durationSeconds\""))
        #expect(!json.contains("\"genreNames\""))
        #expect(!json.contains("\"releaseDate\""))
        #expect(!json.contains("\"hasLyrics\""))
        #expect(!json.contains("\"artworkUrl\""))
        #expect(!json.contains("\"contentRating\""))
    }

    @Test func nullableFieldsOmittedWhenNil() throws {
        let mv = MusicVideoDTO(
            id: "mv-minimal",
            title: "Minimal Video",
            artistName: "Unknown",
            albumTitle: nil,
            durationSeconds: nil,
            genreNames: [],
            releaseDate: nil,
            isrc: nil,
            hasLyrics: nil,
            artworkUrl: nil,
            url: nil,
            contentRating: nil
        )
        let data = try JSONEncoder.aux.encode(mv)
        let json = String(data: data, encoding: .utf8)!

        // Required fields present
        #expect(json.contains("\"id\""))
        #expect(json.contains("\"title\""))
        #expect(json.contains("\"artist_name\""))
        #expect(json.contains("\"genre_names\""))

        // Nil fields omitted
        #expect(!json.contains("\"album_title\""))
        #expect(!json.contains("\"duration_seconds\""))
        #expect(!json.contains("\"release_date\""))
        #expect(!json.contains("\"isrc\""))
        #expect(!json.contains("\"has_lyrics\""))
        #expect(!json.contains("\"artwork_url\""))
        #expect(!json.contains("\"url\""))
        #expect(!json.contains("\"content_rating\""))
    }
}

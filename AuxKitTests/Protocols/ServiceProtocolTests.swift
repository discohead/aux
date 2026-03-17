//
//  ServiceProtocolTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

// MARK: - MusicCatalogService Tests

struct MusicCatalogServiceTests {

    @Test func stubConformsToProtocol() async throws {
        struct Stub: MusicCatalogService {
            func searchSongs(query: String, limit: Int, offset: Int) async throws -> [SongDTO] { [] }
            func searchAlbums(query: String, limit: Int, offset: Int) async throws -> [AlbumDTO] { [] }
            func searchArtists(query: String, limit: Int, offset: Int) async throws -> [ArtistDTO] { [] }
            func searchPlaylists(query: String, limit: Int, offset: Int) async throws -> [PlaylistDTO] { [] }
            func searchMusicVideos(query: String, limit: Int, offset: Int) async throws -> [MusicVideoDTO] { [] }
            func searchStations(query: String, limit: Int, offset: Int) async throws -> [StationDTO] { [] }
            func searchCurators(query: String, limit: Int, offset: Int) async throws -> [CuratorDTO] { [] }
            func searchRadioShows(query: String, limit: Int, offset: Int) async throws -> [RadioShowDTO] { [] }
            func searchAll(query: String, types: [String], limit: Int, offset: Int) async throws -> SearchAllResult {
                SearchAllResult()
            }
            func getSuggestions(query: String, limit: Int, types: [String]?) async throws -> SuggestionsResult {
                SuggestionsResult(terms: [], topResults: nil)
            }
            func getSong(id: String) async throws -> SongDTO { SongDTO.fixture() }
            func getSongByISRC(isrc: String) async throws -> [SongDTO] { [] }
            func getAlbum(id: String) async throws -> AlbumDTO { AlbumDTO.fixture() }
            func getAlbumByUPC(upc: String) async throws -> [AlbumDTO] { [] }
            func getArtist(id: String) async throws -> ArtistDTO { ArtistDTO.fixture() }
            func getPlaylist(id: String) async throws -> PlaylistDTO { PlaylistDTO.fixture() }
            func getMusicVideo(id: String) async throws -> MusicVideoDTO { MusicVideoDTO.fixture() }
            func getStation(id: String) async throws -> StationDTO { StationDTO.fixture() }
            func getCurator(id: String) async throws -> CuratorDTO { CuratorDTO.fixture() }
            func getRadioShow(id: String) async throws -> RadioShowDTO { RadioShowDTO.fixture() }
            func getRecordLabel(id: String) async throws -> RecordLabelDTO { RecordLabelDTO.fixture() }
            func getGenre(id: String) async throws -> GenreDTO { GenreDTO.fixture() }
            func getAllGenres() async throws -> [GenreDTO] { [] }
            func getCharts(kinds: [String], types: [String], genreId: String?, limit: Int) async throws -> ChartsResult {
                ChartsResult(charts: [])
            }
            func getStorefront(id: String) async throws -> StorefrontDTO { StorefrontDTO.fixture() }
        }

        let sut: any MusicCatalogService = Stub()
        let songs = try await sut.searchSongs(query: "test", limit: 10, offset: 0)
        #expect(songs.isEmpty)

        let song = try await sut.getSong(id: "1")
        #expect(song.id == "1")

        let charts = try await sut.getCharts(kinds: ["most-played"], types: ["songs"], genreId: nil, limit: 25)
        #expect(charts.charts.isEmpty)
    }
}

// MARK: - MusicLibraryService Tests

struct MusicLibraryServiceTests {

    @Test func stubConformsToProtocol() async throws {
        struct Stub: MusicLibraryService {
            func getSongs(limit: Int, offset: Int, sort: String?, filters: LibrarySongFilters?) async throws -> [SongDTO] { [] }
            func getAlbums(limit: Int, offset: Int, sort: String?, filters: LibraryAlbumFilters?) async throws -> [AlbumDTO] { [] }
            func getArtists(limit: Int, offset: Int, sort: String?, filterName: String?) async throws -> [ArtistDTO] { [] }
            func getPlaylists(limit: Int, offset: Int, sort: String?) async throws -> [PlaylistDTO] { [] }
            func getMusicVideos(limit: Int, offset: Int) async throws -> [MusicVideoDTO] { [] }
            func search(query: String, types: [String], limit: Int) async throws -> LibrarySearchResult {
                LibrarySearchResult()
            }
        }

        let sut: any MusicLibraryService = Stub()
        let songs = try await sut.getSongs(limit: 25, offset: 0, sort: nil, filters: nil)
        #expect(songs.isEmpty)

        let filters = LibrarySongFilters(title: "Test", artist: nil, album: nil, downloadedOnly: true)
        #expect(filters.downloadedOnly == true)
        #expect(filters.title == "Test")

        let albumFilters = LibraryAlbumFilters(title: "Album", artist: "Artist")
        #expect(albumFilters.title == "Album")
        #expect(albumFilters.artist == "Artist")

        let result = try await sut.search(query: "test", types: ["songs"], limit: 10)
        #expect(result.songs == nil)
    }
}

// MARK: - RESTAPIService Tests

struct RESTAPIServiceTests {

    @Test func stubConformsToProtocol() async throws {
        struct Stub: RESTAPIService {
            func get(path: String, queryParams: [String: String]?) async throws -> Data { Data() }
            func post(path: String, body: Data?) async throws -> Data { Data() }
            func put(path: String, body: Data?) async throws -> Data { Data() }
            func delete(path: String) async throws -> Data { Data() }
        }

        let sut: any RESTAPIService = Stub()
        let data = try await sut.get(path: "/v1/catalog/us/songs/123", queryParams: nil)
        #expect(data.isEmpty)

        let postData = try await sut.post(path: "/v1/me/library", body: nil)
        #expect(postData.isEmpty)
    }
}

// MARK: - AppleScriptBridgeProtocol Tests

struct AppleScriptBridgeProtocolTests {

    @Test func stubConformsToProtocol() async throws {
        final class Stub: AppleScriptBridgeProtocol {
            // Playback
            func play(trackId: Int?) async throws -> NowPlayingDTO { NowPlayingDTO.fixture() }
            func pause() async throws {}
            func stop() async throws {}
            func nextTrack() async throws -> NowPlayingDTO { NowPlayingDTO.fixture() }
            func previousTrack() async throws -> NowPlayingDTO { NowPlayingDTO.fixture() }
            func getNowPlaying() async throws -> NowPlayingDTO { NowPlayingDTO.fixture() }
            func getPlayerStatus() async throws -> PlayerStatusResult {
                PlayerStatusResult(state: "playing", shuffleMode: nil, repeatMode: nil, volume: 0.5, airPlayEnabled: false)
            }
            func seek(position: Double) async throws {}
            func setVolume(_ volume: Double) async throws {}
            func setShuffle(_ enabled: Bool) async throws {}
            func setRepeat(_ mode: String) async throws {}
            func playNext(trackId: Int) async throws {}
            func addToQueue(trackId: Int) async throws {}

            // Tags
            func getTrackTags(trackId: Int) async throws -> TrackTagsDTO { TrackTagsDTO.fixture() }
            func setTrackTags(trackId: Int, fields: [String: String]) async throws {}
            func batchSetTrackTags(trackIds: [Int], fields: [String: String]) async throws {}

            // Lyrics
            func getLyrics(trackId: Int) async throws -> String? { nil }
            func setLyrics(trackId: Int, text: String) async throws {}

            // Artwork
            func getArtwork(trackId: Int, index: Int) async throws -> ArtworkResult {
                ArtworkResult(databaseId: trackId, artworkCount: 1, format: "JPEG", filePath: nil, dataBase64: nil)
            }
            func setArtwork(trackId: Int, imagePath: String) async throws {}
            func getArtworkCount(trackId: Int) async throws -> Int { 0 }

            // File info
            func getFileInfo(trackId: Int) async throws -> FileInfoDTO { FileInfoDTO.fixture() }

            // Track management
            func reveal(trackId: Int) async throws -> String { "/path/to/track" }
            func deleteTracks(trackIds: [Int]) async throws {}
            func convertTracks(trackIds: [Int]) async throws -> ConvertResult {
                ConvertResult(converted: true, tracks: [])
            }
            func importFiles(paths: [String], toPlaylist: String?) async throws -> ImportResult {
                ImportResult(imported: true, fileCount: 0, tracks: nil)
            }

            // Play stats
            func getPlayStats(trackId: Int) async throws -> PlayStatsDTO { PlayStatsDTO.fixture() }
            func setPlayStats(trackId: Int, fields: [String: String]) async throws {}
            func resetPlayStats(trackIds: [Int]) async throws {}

            // Playlist management
            func listAllPlaylists() async throws -> [PlaylistInfoResult] { [] }
            func deletePlaylist(name: String) async throws {}
            func renamePlaylist(name: String, newName: String) async throws {}
            func removeTracksFromPlaylist(playlistName: String, trackIds: [Int]) async throws {}
            func reorderPlaylistTracks(playlistName: String, trackIds: [Int]) async throws {}
            func findDuplicatesInPlaylist(playlistName: String) async throws -> [SongDTO] { [] }

            // AirPlay
            func listAirPlayDevices() async throws -> AirPlayDeviceResult {
                AirPlayDeviceResult(devices: [])
            }
            func selectAirPlayDevice(name: String) async throws {}
            func getCurrentAirPlayDevice() async throws -> String? { nil }

            // EQ
            func listEQPresets() async throws -> [String] { [] }
            func getEQ() async throws -> String? { nil }
            func setEQ(preset: String) async throws {}
        }

        let sut: any AppleScriptBridgeProtocol = Stub()
        let nowPlaying = try await sut.play(trackId: nil)
        #expect(nowPlaying.state == "playing")

        let status = try await sut.getPlayerStatus()
        #expect(status.state == "playing")
        #expect(status.volume == 0.5)

        let artwork = try await sut.getArtwork(trackId: 1, index: 0)
        #expect(artwork.databaseId == 1)
        #expect(artwork.artworkCount == 1)

        let devices = try await sut.listAirPlayDevices()
        #expect(devices.devices.isEmpty)
    }
}

// MARK: - AuthService Tests

struct AuthServiceTests {

    @Test func stubConformsToProtocol() async throws {
        struct Stub: AuthService {
            func checkStatus() async throws -> AuthStatusResult {
                AuthStatusResult(authorizationStatus: "authorized", subscription: nil)
            }
            func requestAuthorization() async throws -> AuthStatusResult {
                AuthStatusResult(
                    authorizationStatus: "authorized",
                    subscription: SubscriptionInfo(
                        canPlayCatalogContent: true,
                        canBecomeSubscriber: false,
                        hasCloudLibraryEnabled: true
                    )
                )
            }
            func getToken(type: String) async throws -> TokenResult {
                TokenResult(developerToken: "dev-token", userToken: "user-token")
            }
        }

        let sut: any AuthService = Stub()
        let status = try await sut.checkStatus()
        #expect(status.authorizationStatus == "authorized")
        #expect(status.subscription == nil)

        let fullStatus = try await sut.requestAuthorization()
        #expect(fullStatus.subscription?.canPlayCatalogContent == true)
        #expect(fullStatus.subscription?.hasCloudLibraryEnabled == true)

        let token = try await sut.getToken(type: "developer")
        #expect(token.developerToken == "dev-token")
        #expect(token.userToken == "user-token")
    }
}

// MARK: - RecommendationsService Tests

struct RecommendationsServiceTests {

    @Test func stubConformsToProtocol() async throws {
        struct Stub: RecommendationsService {
            func getRecommendations(limit: Int) async throws -> RecommendationsResult {
                RecommendationsResult(recommendations: [
                    RecommendationGroup(title: "Made for You", types: ["personal-mix"], albums: nil, playlists: nil, stations: nil)
                ])
            }
        }

        let sut: any RecommendationsService = Stub()
        let result = try await sut.getRecommendations(limit: 10)
        #expect(result.recommendations.count == 1)
        #expect(result.recommendations[0].title == "Made for You")
        #expect(result.recommendations[0].types == ["personal-mix"])
    }
}

// MARK: - RecentlyPlayedService Tests

struct RecentlyPlayedServiceTests {

    @Test func stubConformsToProtocol() async throws {
        struct Stub: RecentlyPlayedService {
            func getRecentlyPlayedTracks(limit: Int) async throws -> [TrackDTO] { [] }
            func getRecentlyPlayedContainers(limit: Int) async throws -> RecentlyPlayedContainersResult {
                RecentlyPlayedContainersResult(items: [
                    RecentlyPlayedContainer(type: "album", id: "a-1", name: "Recent Album")
                ])
            }
        }

        let sut: any RecentlyPlayedService = Stub()
        let tracks = try await sut.getRecentlyPlayedTracks(limit: 10)
        #expect(tracks.isEmpty)

        let containers = try await sut.getRecentlyPlayedContainers(limit: 10)
        #expect(containers.items.count == 1)
        #expect(containers.items[0].type == "album")
        #expect(containers.items[0].id == "a-1")
        #expect(containers.items[0].name == "Recent Album")
    }
}

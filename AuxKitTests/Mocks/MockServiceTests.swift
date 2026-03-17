//
//  MockServiceTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

// MARK: - MockMusicCatalogService Tests

struct MockMusicCatalogServiceTests {

    @Test func mockCatalogReturnsConfiguredSongs() async throws {
        let mock = MockMusicCatalogService()
        let expected = [SongDTO.fixture(id: "s1", title: "Mock Song")]
        mock.searchSongsResult = .success(expected)

        let result = try await mock.searchSongs(query: "test", limit: 10, offset: 0)
        #expect(result == expected)
    }

    @Test func mockCatalogRecordsMethodCalls() async throws {
        let mock = MockMusicCatalogService()
        #expect(mock.searchSongsCalled == false)

        _ = try await mock.searchSongs(query: "test", limit: 10, offset: 0)
        #expect(mock.searchSongsCalled == true)
    }

    @Test func mockCatalogThrowsConfiguredError() async throws {
        let mock = MockMusicCatalogService()
        mock.searchSongsResult = .failure(AuxError.networkError(message: "test"))

        await #expect(throws: AuxError.self) {
            _ = try await mock.searchSongs(query: "test", limit: 10, offset: 0)
        }
    }

    @Test func mockCatalogTracksSearchAlbumsCalls() async throws {
        let mock = MockMusicCatalogService()
        #expect(mock.searchAlbumsCalled == false)

        _ = try await mock.searchAlbums(query: "test", limit: 10, offset: 0)
        #expect(mock.searchAlbumsCalled == true)
    }

    @Test func mockCatalogTracksGetSongCalls() async throws {
        let mock = MockMusicCatalogService()
        let expected = SongDTO.fixture(id: "42")
        mock.getSongResult = .success(expected)

        let result = try await mock.getSong(id: "42")
        #expect(result == expected)
        #expect(mock.getSongCalled == true)
    }

    @Test func mockCatalogTracksGetAlbumCalls() async throws {
        let mock = MockMusicCatalogService()
        let expected = AlbumDTO.fixture(id: "a1")
        mock.getAlbumResult = .success(expected)

        let result = try await mock.getAlbum(id: "a1")
        #expect(result == expected)
        #expect(mock.getAlbumCalled == true)
    }

    @Test func mockCatalogTracksGetArtistCalls() async throws {
        let mock = MockMusicCatalogService()
        let expected = ArtistDTO.fixture(id: "ar1")
        mock.getArtistResult = .success(expected)

        let result = try await mock.getArtist(id: "ar1")
        #expect(result == expected)
        #expect(mock.getArtistCalled == true)
    }

    @Test func mockCatalogTracksGetChartsCalls() async throws {
        let mock = MockMusicCatalogService()
        #expect(mock.getChartsCalled == false)

        _ = try await mock.getCharts(kinds: ["most-played"], types: ["songs"], genreId: nil, limit: 10)
        #expect(mock.getChartsCalled == true)
    }

    @Test func resetClearsAllFlags() async throws {
        let mock = MockMusicCatalogService()
        _ = try await mock.searchSongs(query: "test", limit: 10, offset: 0)
        _ = try await mock.getSong(id: "1")
        #expect(mock.searchSongsCalled == true)
        #expect(mock.getSongCalled == true)

        mock.reset()
        #expect(mock.searchSongsCalled == false)
        #expect(mock.getSongCalled == false)
    }
}

// MARK: - MockAppleScriptBridge Tests

struct MockAppleScriptBridgeTests {

    @Test func mockAppleScriptReturnsConfiguredNowPlaying() async throws {
        let mock = MockAppleScriptBridge()
        let expected = NowPlayingDTO.fixture(title: "Mock Song", artistName: "Mock Artist")
        mock.getNowPlayingResult = .success(expected)

        let result = try await mock.getNowPlaying()
        #expect(result == expected)
        #expect(result.title == "Mock Song")
        #expect(result.artistName == "Mock Artist")
    }

    @Test func mockAppleScriptPauseRecordsCall() async throws {
        let mock = MockAppleScriptBridge()
        #expect(mock.pauseCalled == false)

        try await mock.pause()
        #expect(mock.pauseCalled == true)
    }

    @Test func mockAppleScriptPlayRecordsCall() async throws {
        let mock = MockAppleScriptBridge()
        #expect(mock.playCalled == false)

        _ = try await mock.play(trackId: nil)
        #expect(mock.playCalled == true)
    }

    @Test func mockAppleScriptStopRecordsCall() async throws {
        let mock = MockAppleScriptBridge()
        #expect(mock.stopCalled == false)

        try await mock.stop()
        #expect(mock.stopCalled == true)
    }

    @Test func mockAppleScriptGetNowPlayingRecordsCall() async throws {
        let mock = MockAppleScriptBridge()
        #expect(mock.getNowPlayingCalled == false)

        _ = try await mock.getNowPlaying()
        #expect(mock.getNowPlayingCalled == true)
    }

    @Test func mockAppleScriptGetTrackTagsRecordsCall() async throws {
        let mock = MockAppleScriptBridge()
        #expect(mock.getTrackTagsCalled == false)

        _ = try await mock.getTrackTags(trackId: 1)
        #expect(mock.getTrackTagsCalled == true)
    }

    @Test func mockAppleScriptSetTrackTagsRecordsCall() async throws {
        let mock = MockAppleScriptBridge()
        #expect(mock.setTrackTagsCalled == false)

        try await mock.setTrackTags(trackId: 1, fields: ["name": "New Name"])
        #expect(mock.setTrackTagsCalled == true)
    }

    @Test func resetClearsAllFlags() async throws {
        let mock = MockAppleScriptBridge()
        _ = try await mock.play(trackId: nil)
        try await mock.pause()
        #expect(mock.playCalled == true)
        #expect(mock.pauseCalled == true)

        mock.reset()
        #expect(mock.playCalled == false)
        #expect(mock.pauseCalled == false)
    }
}

// MARK: - MockRESTAPIService Tests

struct MockRESTAPIServiceTests {

    @Test func mockRESTGetReturnsConfiguredData() async throws {
        let mock = MockRESTAPIService()
        let expected = Data("{\"key\":\"value\"}".utf8)
        mock.getResult = .success(expected)

        let result = try await mock.get(path: "/test", queryParams: nil)
        #expect(result == expected)
        #expect(mock.getCalled == true)
    }

    @Test func mockRESTPostRecordsCall() async throws {
        let mock = MockRESTAPIService()
        #expect(mock.postCalled == false)

        _ = try await mock.post(path: "/test", body: nil)
        #expect(mock.postCalled == true)
    }

    @Test func mockRESTPutRecordsCall() async throws {
        let mock = MockRESTAPIService()
        #expect(mock.putCalled == false)

        _ = try await mock.put(path: "/test", body: nil)
        #expect(mock.putCalled == true)
    }

    @Test func mockRESTDeleteRecordsCall() async throws {
        let mock = MockRESTAPIService()
        #expect(mock.deleteCalled == false)

        _ = try await mock.delete(path: "/test")
        #expect(mock.deleteCalled == true)
    }

    @Test func resetClearsAllFlags() async throws {
        let mock = MockRESTAPIService()
        _ = try await mock.get(path: "/test", queryParams: nil)
        _ = try await mock.post(path: "/test", body: nil)
        #expect(mock.getCalled == true)
        #expect(mock.postCalled == true)

        mock.reset()
        #expect(mock.getCalled == false)
        #expect(mock.postCalled == false)
    }
}

// MARK: - MockMusicLibraryService Tests

struct MockMusicLibraryServiceTests {

    @Test func mockLibraryGetSongsReturnsConfiguredData() async throws {
        let mock = MockMusicLibraryService()
        let expected = [SongDTO.fixture(id: "lib1")]
        mock.getSongsResult = .success(expected)

        let result = try await mock.getSongs(limit: 10, offset: 0, sort: nil, filters: nil)
        #expect(result == expected)
        #expect(mock.getSongsCalled == true)
    }

    @Test func mockLibraryGetAlbumsRecordsCall() async throws {
        let mock = MockMusicLibraryService()
        #expect(mock.getAlbumsCalled == false)

        _ = try await mock.getAlbums(limit: 10, offset: 0, sort: nil, filters: nil)
        #expect(mock.getAlbumsCalled == true)
    }

    @Test func mockLibrarySearchRecordsCall() async throws {
        let mock = MockMusicLibraryService()
        #expect(mock.searchCalled == false)

        _ = try await mock.search(query: "test", types: ["songs"], limit: 10)
        #expect(mock.searchCalled == true)
    }

    @Test func resetClearsAllFlags() async throws {
        let mock = MockMusicLibraryService()
        _ = try await mock.getSongs(limit: 10, offset: 0, sort: nil, filters: nil)
        _ = try await mock.search(query: "test", types: ["songs"], limit: 10)
        #expect(mock.getSongsCalled == true)
        #expect(mock.searchCalled == true)

        mock.reset()
        #expect(mock.getSongsCalled == false)
        #expect(mock.searchCalled == false)
    }
}

// MARK: - MockAuthService Tests

struct MockAuthServiceTests {

    @Test func mockAuthCheckStatusReturnsConfiguredResult() async throws {
        let mock = MockAuthService()
        let expected = AuthStatusResult(authorizationStatus: "authorized")
        mock.checkStatusResult = .success(expected)

        let result = try await mock.checkStatus()
        #expect(result == expected)
        #expect(mock.checkStatusCalled == true)
    }

    @Test func mockAuthRequestAuthorizationRecordsCall() async throws {
        let mock = MockAuthService()
        #expect(mock.requestAuthorizationCalled == false)

        _ = try await mock.requestAuthorization()
        #expect(mock.requestAuthorizationCalled == true)
    }

    @Test func mockAuthGetTokenRecordsCall() async throws {
        let mock = MockAuthService()
        #expect(mock.getTokenCalled == false)

        _ = try await mock.getToken(type: "developer")
        #expect(mock.getTokenCalled == true)
    }

    @Test func resetClearsAllFlags() async throws {
        let mock = MockAuthService()
        _ = try await mock.checkStatus()
        _ = try await mock.getToken(type: "developer")
        #expect(mock.checkStatusCalled == true)
        #expect(mock.getTokenCalled == true)

        mock.reset()
        #expect(mock.checkStatusCalled == false)
        #expect(mock.getTokenCalled == false)
    }
}

// MARK: - MockRecommendationsService Tests

struct MockRecommendationsServiceTests {

    @Test func mockRecommendationsReturnsConfiguredResult() async throws {
        let mock = MockRecommendationsService()
        let expected = RecommendationsResult(recommendations: [
            RecommendationGroup(title: "For You", types: ["albums"])
        ])
        mock.getRecommendationsResult = .success(expected)

        let result = try await mock.getRecommendations(limit: 10)
        #expect(result == expected)
        #expect(mock.getRecommendationsCalled == true)
    }

    @Test func resetClearsAllFlags() async throws {
        let mock = MockRecommendationsService()
        _ = try await mock.getRecommendations(limit: 10)
        #expect(mock.getRecommendationsCalled == true)

        mock.reset()
        #expect(mock.getRecommendationsCalled == false)
    }
}

// MARK: - MockRecentlyPlayedService Tests

struct MockRecentlyPlayedServiceTests {

    @Test func mockRecentlyPlayedTracksReturnsConfiguredResult() async throws {
        let mock = MockRecentlyPlayedService()
        let expected = [TrackDTO.fixture()]
        mock.getRecentlyPlayedTracksResult = .success(expected)

        let result = try await mock.getRecentlyPlayedTracks(limit: 10)
        #expect(result == expected)
        #expect(mock.getRecentlyPlayedTracksCalled == true)
    }

    @Test func mockRecentlyPlayedContainersRecordsCall() async throws {
        let mock = MockRecentlyPlayedService()
        #expect(mock.getRecentlyPlayedContainersCalled == false)

        _ = try await mock.getRecentlyPlayedContainers(limit: 10)
        #expect(mock.getRecentlyPlayedContainersCalled == true)
    }

    @Test func resetClearsAllFlags() async throws {
        let mock = MockRecentlyPlayedService()
        _ = try await mock.getRecentlyPlayedTracks(limit: 10)
        _ = try await mock.getRecentlyPlayedContainers(limit: 10)
        #expect(mock.getRecentlyPlayedTracksCalled == true)
        #expect(mock.getRecentlyPlayedContainersCalled == true)

        mock.reset()
        #expect(mock.getRecentlyPlayedTracksCalled == false)
        #expect(mock.getRecentlyPlayedContainersCalled == false)
    }
}

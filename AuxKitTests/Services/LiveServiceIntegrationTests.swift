//
//  LiveServiceIntegrationTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
@testable import AuxKit

// MARK: - LiveAuthService

struct LiveAuthServiceIntegrationTests {
    @Test(.disabled("Requires MusicKit authorization"))
    func checkStatusReturnsResult() async throws {
        let service = LiveAuthService()
        let result = try await service.checkStatus()
        #expect(!result.authorizationStatus.isEmpty)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func requestAuthorizationReturnsResult() async throws {
        let service = LiveAuthService()
        let result = try await service.requestAuthorization()
        #expect(!result.authorizationStatus.isEmpty)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func getTokenReturnsResult() async throws {
        let service = LiveAuthService()
        let result = try await service.getToken(type: "developer")
        // Tokens may be nil since MusicKit manages them internally
        _ = result
    }
}

// MARK: - LiveMusicCatalogService

struct LiveCatalogServiceIntegrationTests {
    @Test(.disabled("Requires MusicKit authorization"))
    func searchSongsReturnsResults() async throws {
        let service = LiveMusicCatalogService()
        let results = try await service.searchSongs(query: "Beatles", limit: 5, offset: 0)
        #expect(!results.isEmpty)
        #expect(!results[0].title.isEmpty)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func searchAlbumsReturnsResults() async throws {
        let service = LiveMusicCatalogService()
        let results = try await service.searchAlbums(query: "Abbey Road", limit: 5, offset: 0)
        #expect(!results.isEmpty)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func searchArtistsReturnsResults() async throws {
        let service = LiveMusicCatalogService()
        let results = try await service.searchArtists(query: "Taylor Swift", limit: 5, offset: 0)
        #expect(!results.isEmpty)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func getSongByIdReturnsDTO() async throws {
        let service = LiveMusicCatalogService()
        let song = try await service.getSong(id: "1440833237")
        #expect(!song.title.isEmpty)
        #expect(!song.artistName.isEmpty)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func getAlbumByIdReturnsDTO() async throws {
        let service = LiveMusicCatalogService()
        let album = try await service.getAlbum(id: "1440833231")
        #expect(!album.title.isEmpty)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func searchAllReturnsMultipleTypes() async throws {
        let service = LiveMusicCatalogService()
        let result = try await service.searchAll(
            query: "Beatles",
            types: ["songs", "albums", "artists"],
            limit: 5,
            offset: 0
        )
        // At least one type should have results
        let hasResults = (result.songs != nil) || (result.albums != nil) || (result.artists != nil)
        #expect(hasResults)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func getSuggestionsReturnsTerms() async throws {
        let service = LiveMusicCatalogService()
        let result = try await service.getSuggestions(query: "Beat", limit: 5, types: nil)
        #expect(!result.terms.isEmpty)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func getChartsReturnsEntries() async throws {
        let service = LiveMusicCatalogService()
        let result = try await service.getCharts(
            kinds: ["most-played"],
            types: ["songs"],
            genreId: nil,
            limit: 5
        )
        #expect(!result.charts.isEmpty)
    }
}

// MARK: - LiveMusicLibraryService

struct LiveLibraryServiceIntegrationTests {
    @Test(.disabled("Requires MusicKit authorization"))
    func getSongsReturnsLibraryItems() async throws {
        let service = LiveMusicLibraryService()
        let results = try await service.getSongs(limit: 5, offset: 0, sort: nil, filters: nil)
        #expect(!results.isEmpty)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func getAlbumsReturnsLibraryItems() async throws {
        let service = LiveMusicLibraryService()
        let results = try await service.getAlbums(limit: 5, offset: 0, sort: nil, filters: nil)
        #expect(!results.isEmpty)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func searchLibraryReturnsResults() async throws {
        let service = LiveMusicLibraryService()
        let result = try await service.search(query: "test", types: ["songs"], limit: 5)
        // May or may not have results depending on library contents
        _ = result
    }
}

// MARK: - LiveRESTAPIService

struct LiveRESTAPIServiceIntegrationTests {
    @Test(.disabled("Requires MusicKit authorization"))
    func getStorefrontReturnsData() async throws {
        let service = LiveRESTAPIService()
        let data = try await service.get(path: "/v1/storefronts/us", queryParams: nil)
        #expect(!data.isEmpty)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func getCatalogSongReturnsData() async throws {
        let service = LiveRESTAPIService()
        let data = try await service.get(
            path: "/v1/catalog/us/songs/1440833237",
            queryParams: nil
        )
        #expect(!data.isEmpty)
    }
}

// MARK: - LiveRecommendationsService

struct LiveRecommendationsServiceIntegrationTests {
    @Test(.disabled("Requires MusicKit authorization"))
    func getRecommendationsReturnsGroups() async throws {
        let service = LiveRecommendationsService()
        let result = try await service.getRecommendations(limit: 5)
        #expect(!result.recommendations.isEmpty)
    }
}

// MARK: - LiveRecentlyPlayedService

struct LiveRecentlyPlayedServiceIntegrationTests {
    @Test(.disabled("Requires MusicKit authorization"))
    func getRecentlyPlayedTracksReturnsTracks() async throws {
        let service = LiveRecentlyPlayedService()
        let results = try await service.getRecentlyPlayedTracks(limit: 5)
        #expect(!results.isEmpty)
    }

    @Test(.disabled("Requires MusicKit authorization"))
    func getRecentlyPlayedContainersReturnsItems() async throws {
        let service = LiveRecentlyPlayedService()
        let result = try await service.getRecentlyPlayedContainers(limit: 5)
        #expect(!result.items.isEmpty)
    }
}

// MARK: - LiveAppleScriptBridge

struct LiveAppleScriptBridgeIntegrationTests {
    @Test(.disabled("Requires Music.app running with a track"))
    func getNowPlayingReturnsDTO() async throws {
        let bridge = LiveAppleScriptBridge()
        let result = try await bridge.getNowPlaying()
        #expect(!result.title.isEmpty)
        #expect(!result.artistName.isEmpty)
    }

    @Test(.disabled("Requires Music.app running"))
    func getPlayerStatusReturnsResult() async throws {
        let bridge = LiveAppleScriptBridge()
        let result = try await bridge.getPlayerStatus()
        #expect(!result.state.isEmpty)
    }

    @Test(.disabled("Requires Music.app running with tracks"))
    func getPlayStatsReturnsDTO() async throws {
        let bridge = LiveAppleScriptBridge()
        // Use a known database ID from your library
        let result = try await bridge.getPlayStats(trackId: 1)
        #expect(!result.name.isEmpty)
    }
}

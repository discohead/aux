//
//  ServiceContainerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

struct ServiceContainerTests {

    @Test func defaultContainerProvidesMocks() {
        let container = ServiceContainer.mock()

        #expect(container.catalog is MockMusicCatalogService)
        #expect(container.library is MockMusicLibraryService)
        #expect(container.restAPI is MockRESTAPIService)
        #expect(container.appleScript is MockAppleScriptBridge)
        #expect(container.auth is MockAuthService)
        #expect(container.recommendations is MockRecommendationsService)
        #expect(container.recentlyPlayed is MockRecentlyPlayedService)
        #expect(container.history is MockHistoryService)
        #expect(container.summaries is MockSummariesService)
        #expect(container.favorites is MockFavoritesService)
    }

    @Test func containerAcceptsCustomServices() {
        let customCatalog = MockMusicCatalogService()
        let customLibrary = MockMusicLibraryService()
        let customREST = MockRESTAPIService()
        let customAppleScript = MockAppleScriptBridge()
        let customAuth = MockAuthService()
        let customRecs = MockRecommendationsService()
        let customRecent = MockRecentlyPlayedService()
        let customHistory = MockHistoryService()
        let customSummaries = MockSummariesService()
        let customFavorites = MockFavoritesService()

        let container = ServiceContainer(
            catalog: customCatalog,
            library: customLibrary,
            restAPI: customREST,
            appleScript: customAppleScript,
            auth: customAuth,
            recommendations: customRecs,
            recentlyPlayed: customRecent,
            history: customHistory,
            summaries: customSummaries,
            favorites: customFavorites
        )

        #expect(container.catalog as AnyObject === customCatalog)
        #expect(container.library as AnyObject === customLibrary)
        #expect(container.restAPI as AnyObject === customREST)
        #expect(container.appleScript as AnyObject === customAppleScript)
        #expect(container.auth as AnyObject === customAuth)
        #expect(container.recommendations as AnyObject === customRecs)
        #expect(container.recentlyPlayed as AnyObject === customRecent)
        #expect(container.history as AnyObject === customHistory)
        #expect(container.summaries as AnyObject === customSummaries)
        #expect(container.favorites as AnyObject === customFavorites)
    }
}

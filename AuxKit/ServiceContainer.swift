//
//  ServiceContainer.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Dependency injection container holding all service protocol instances.
public struct ServiceContainer: Sendable {
    public let catalog: any MusicCatalogService
    public let library: any MusicLibraryService
    public let restAPI: any RESTAPIService
    public let appleScript: any AppleScriptBridgeProtocol
    public let auth: any AuthService
    public let recommendations: any RecommendationsService
    public let recentlyPlayed: any RecentlyPlayedService
    public let history: any HistoryService
    public let summaries: any SummariesService
    public let favorites: any FavoritesService

    public init(
        catalog: any MusicCatalogService,
        library: any MusicLibraryService,
        restAPI: any RESTAPIService,
        appleScript: any AppleScriptBridgeProtocol,
        auth: any AuthService,
        recommendations: any RecommendationsService,
        recentlyPlayed: any RecentlyPlayedService,
        history: any HistoryService,
        summaries: any SummariesService,
        favorites: any FavoritesService
    ) {
        self.catalog = catalog
        self.library = library
        self.restAPI = restAPI
        self.appleScript = appleScript
        self.auth = auth
        self.recommendations = recommendations
        self.recentlyPlayed = recentlyPlayed
        self.history = history
        self.summaries = summaries
        self.favorites = favorites
    }

    /// Creates a container with live service implementations for production use.
    @available(macOS 14.0, *)
    public static func live() -> ServiceContainer {
        ServiceContainer(
            catalog: LiveMusicCatalogService(),
            library: LiveMusicLibraryService(),
            restAPI: LiveRESTAPIService(),
            appleScript: LiveAppleScriptBridge(),
            auth: LiveAuthService(),
            recommendations: LiveRecommendationsService(),
            recentlyPlayed: LiveRecentlyPlayedService(),
            history: LiveHistoryService(),
            summaries: LiveSummariesService(),
            favorites: LiveFavoritesService()
        )
    }

    /// Creates a container pre-populated with mock service implementations for testing.
    public static func mock() -> ServiceContainer {
        ServiceContainer(
            catalog: MockMusicCatalogService(),
            library: MockMusicLibraryService(),
            restAPI: MockRESTAPIService(),
            appleScript: MockAppleScriptBridge(),
            auth: MockAuthService(),
            recommendations: MockRecommendationsService(),
            recentlyPlayed: MockRecentlyPlayedService(),
            history: MockHistoryService(),
            summaries: MockSummariesService(),
            favorites: MockFavoritesService()
        )
    }
}

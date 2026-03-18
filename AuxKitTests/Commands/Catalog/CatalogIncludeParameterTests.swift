//
//  CatalogIncludeParameterTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation
import Testing
@testable import AuxKit

// MARK: - Song Include Tests

struct CatalogSongIncludeTests {

    @Test func includePassedToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogSongHandler.handle(
            services: container, options: GlobalOptions(), id: "123",
            include: ["artists", "albums"], writer: writer
        )

        #expect(mock.getSongCalled)
        #expect(mock.lastInclude == ["artists", "albums"])
    }

    @Test func includeNilByDefault() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogSongHandler.handle(
            services: container, options: GlobalOptions(), id: "123", writer: writer
        )

        #expect(mock.getSongCalled)
        #expect(mock.lastInclude == nil)
    }
}

// MARK: - Album Include Tests

struct CatalogAlbumIncludeTests {

    @Test func includePassedToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogAlbumHandler.handle(
            services: container, options: GlobalOptions(), id: "456",
            include: ["artists", "tracks"], writer: writer
        )

        #expect(mock.getAlbumCalled)
        #expect(mock.lastInclude == ["artists", "tracks"])
    }

    @Test func includeNilByDefault() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogAlbumHandler.handle(
            services: container, options: GlobalOptions(), id: "456", writer: writer
        )

        #expect(mock.getAlbumCalled)
        #expect(mock.lastInclude == nil)
    }
}

// MARK: - Artist Include Tests

struct CatalogArtistIncludeTests {

    @Test func includePassedToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogArtistHandler.handle(
            services: container, options: GlobalOptions(), id: "789",
            include: ["albums", "songs"], writer: writer
        )

        #expect(mock.getArtistCalled)
        #expect(mock.lastInclude == ["albums", "songs"])
    }

    @Test func includeNilByDefault() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogArtistHandler.handle(
            services: container, options: GlobalOptions(), id: "789", writer: writer
        )

        #expect(mock.getArtistCalled)
        #expect(mock.lastInclude == nil)
    }
}

// MARK: - Playlist Include Tests

struct CatalogPlaylistIncludeTests {

    @Test func includePassedToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogPlaylistHandler.handle(
            services: container, options: GlobalOptions(), id: "pl.1",
            include: ["tracks", "curator"], writer: writer
        )

        #expect(mock.getPlaylistCalled)
        #expect(mock.lastInclude == ["tracks", "curator"])
    }

    @Test func includeNilByDefault() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogPlaylistHandler.handle(
            services: container, options: GlobalOptions(), id: "pl.1", writer: writer
        )

        #expect(mock.getPlaylistCalled)
        #expect(mock.lastInclude == nil)
    }
}

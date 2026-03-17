//
//  CatalogPlaylistHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogPlaylistHandlerTests {

    @Test func callsGetPlaylist() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogPlaylistHandler.handle(
            services: container, options: GlobalOptions(), id: "pl.123", writer: writer
        )

        #expect(mock.getPlaylistCalled)
    }

    @Test func returnsCorrectDTO() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getPlaylistResult = .success(.fixture(id: "pl.42", name: "My Playlist"))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogPlaylistHandler.handle(
            services: container, options: GlobalOptions(), id: "pl.42", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("My Playlist"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getPlaylistResult = .failure(AuxError.notFound(message: "Playlist not found"))

        await #expect(throws: AuxError.self) {
            try await CatalogPlaylistHandler.handle(
                services: container, options: GlobalOptions(), id: "bad",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

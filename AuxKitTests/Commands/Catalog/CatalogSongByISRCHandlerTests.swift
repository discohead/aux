//
//  CatalogSongByISRCHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogSongByISRCHandlerTests {

    @Test func callsGetSongByISRC() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogSongByISRCHandler.handle(
            services: container, options: GlobalOptions(), isrc: "USAT21234567", writer: writer
        )

        #expect(mock.getSongByISRCCalled)
    }

    @Test func returnsCorrectDTOs() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getSongByISRCResult = .success([.fixture(id: "42", title: "ISRC Song")])

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogSongByISRCHandler.handle(
            services: container, options: GlobalOptions(), isrc: "USAT21234567", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("ISRC Song"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getSongByISRCResult = .failure(AuxError.notFound(message: "No songs found"))

        await #expect(throws: AuxError.self) {
            try await CatalogSongByISRCHandler.handle(
                services: container, options: GlobalOptions(), isrc: "bad",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

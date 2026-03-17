//
//  CatalogArtistHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogArtistHandlerTests {

    @Test func callsGetArtist() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogArtistHandler.handle(
            services: container, options: GlobalOptions(), id: "123", writer: writer
        )

        #expect(mock.getArtistCalled)
    }

    @Test func returnsCorrectDTO() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getArtistResult = .success(.fixture(id: "42", name: "My Artist"))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogArtistHandler.handle(
            services: container, options: GlobalOptions(), id: "42", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("My Artist"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getArtistResult = .failure(AuxError.notFound(message: "Artist not found"))

        await #expect(throws: AuxError.self) {
            try await CatalogArtistHandler.handle(
                services: container, options: GlobalOptions(), id: "bad",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

//
//  CatalogGenreHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogGenreHandlerTests {

    @Test func callsGetGenre() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogGenreHandler.handle(
            services: container, options: GlobalOptions(), id: "14", writer: writer
        )

        #expect(mock.getGenreCalled)
    }

    @Test func returnsCorrectDTO() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getGenreResult = .success(.fixture(id: "14", name: "Pop"))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogGenreHandler.handle(
            services: container, options: GlobalOptions(), id: "14", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("Pop"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getGenreResult = .failure(AuxError.notFound(message: "Genre not found"))

        await #expect(throws: AuxError.self) {
            try await CatalogGenreHandler.handle(
                services: container, options: GlobalOptions(), id: "bad",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

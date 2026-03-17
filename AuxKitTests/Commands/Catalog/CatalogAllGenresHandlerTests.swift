//
//  CatalogAllGenresHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogAllGenresHandlerTests {

    @Test func callsGetAllGenres() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogAllGenresHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )

        #expect(mock.getAllGenresCalled)
    }

    @Test func returnsCorrectDTOs() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getAllGenresResult = .success([
            .fixture(id: "14", name: "Pop"),
            .fixture(id: "21", name: "Rock")
        ])

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogAllGenresHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("Pop"))
        #expect(json.contains("Rock"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getAllGenresResult = .failure(AuxError.networkError(message: "Network error"))

        await #expect(throws: AuxError.self) {
            try await CatalogAllGenresHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

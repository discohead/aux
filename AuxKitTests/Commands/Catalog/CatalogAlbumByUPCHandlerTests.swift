//
//  CatalogAlbumByUPCHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogAlbumByUPCHandlerTests {

    @Test func callsGetAlbumByUPC() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogAlbumByUPCHandler.handle(
            services: container, options: GlobalOptions(), upc: "012345678901", writer: writer
        )

        #expect(mock.getAlbumByUPCCalled)
    }

    @Test func returnsCorrectDTOs() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getAlbumByUPCResult = .success([.fixture(id: "42", title: "UPC Album")])

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogAlbumByUPCHandler.handle(
            services: container, options: GlobalOptions(), upc: "012345678901", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("UPC Album"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getAlbumByUPCResult = .failure(AuxError.notFound(message: "No albums found"))

        await #expect(throws: AuxError.self) {
            try await CatalogAlbumByUPCHandler.handle(
                services: container, options: GlobalOptions(), upc: "bad",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

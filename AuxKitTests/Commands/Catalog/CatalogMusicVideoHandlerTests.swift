//
//  CatalogMusicVideoHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogMusicVideoHandlerTests {

    @Test func callsGetMusicVideo() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogMusicVideoHandler.handle(
            services: container, options: GlobalOptions(), id: "mv.123", writer: writer
        )

        #expect(mock.getMusicVideoCalled)
    }

    @Test func returnsCorrectDTO() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getMusicVideoResult = .success(.fixture(id: "mv.42", title: "My Music Video"))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogMusicVideoHandler.handle(
            services: container, options: GlobalOptions(), id: "mv.42", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("My Music Video"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getMusicVideoResult = .failure(AuxError.notFound(message: "Music video not found"))

        await #expect(throws: AuxError.self) {
            try await CatalogMusicVideoHandler.handle(
                services: container, options: GlobalOptions(), id: "bad",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

//
//  CatalogCuratorHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogCuratorHandlerTests {

    @Test func callsGetCurator() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogCuratorHandler.handle(
            services: container, options: GlobalOptions(), id: "c.123", writer: writer
        )

        #expect(mock.getCuratorCalled)
    }

    @Test func returnsCorrectDTO() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getCuratorResult = .success(.fixture(id: "c.42", name: "My Curator"))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogCuratorHandler.handle(
            services: container, options: GlobalOptions(), id: "c.42", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("My Curator"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getCuratorResult = .failure(AuxError.notFound(message: "Curator not found"))

        await #expect(throws: AuxError.self) {
            try await CatalogCuratorHandler.handle(
                services: container, options: GlobalOptions(), id: "bad",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

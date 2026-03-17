//
//  CatalogStorefrontHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogStorefrontHandlerTests {

    @Test func callsGetStorefront() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogStorefrontHandler.handle(
            services: container, options: GlobalOptions(), id: "us", writer: writer
        )

        #expect(mock.getStorefrontCalled)
    }

    @Test func returnsCorrectDTO() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getStorefrontResult = .success(.fixture(id: "us", name: "United States"))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogStorefrontHandler.handle(
            services: container, options: GlobalOptions(), id: "us", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("United States"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getStorefrontResult = .failure(AuxError.notFound(message: "Storefront not found"))

        await #expect(throws: AuxError.self) {
            try await CatalogStorefrontHandler.handle(
                services: container, options: GlobalOptions(), id: "bad",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

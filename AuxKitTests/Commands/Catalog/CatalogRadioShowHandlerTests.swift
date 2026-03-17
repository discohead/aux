//
//  CatalogRadioShowHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogRadioShowHandlerTests {

    @Test func callsGetRadioShow() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogRadioShowHandler.handle(
            services: container, options: GlobalOptions(), id: "rs.123", writer: writer
        )

        #expect(mock.getRadioShowCalled)
    }

    @Test func returnsCorrectDTO() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getRadioShowResult = .success(.fixture(id: "rs.42", name: "My Radio Show"))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogRadioShowHandler.handle(
            services: container, options: GlobalOptions(), id: "rs.42", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("My Radio Show"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getRadioShowResult = .failure(AuxError.notFound(message: "Radio show not found"))

        await #expect(throws: AuxError.self) {
            try await CatalogRadioShowHandler.handle(
                services: container, options: GlobalOptions(), id: "bad",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

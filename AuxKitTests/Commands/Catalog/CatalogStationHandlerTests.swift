//
//  CatalogStationHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogStationHandlerTests {

    @Test func callsGetStation() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogStationHandler.handle(
            services: container, options: GlobalOptions(), id: "st.123", writer: writer
        )

        #expect(mock.getStationCalled)
    }

    @Test func returnsCorrectDTO() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getStationResult = .success(.fixture(id: "st.42", name: "My Station"))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogStationHandler.handle(
            services: container, options: GlobalOptions(), id: "st.42", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("My Station"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getStationResult = .failure(AuxError.notFound(message: "Station not found"))

        await #expect(throws: AuxError.self) {
            try await CatalogStationHandler.handle(
                services: container, options: GlobalOptions(), id: "bad",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

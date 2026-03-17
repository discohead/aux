//
//  CatalogRecordLabelHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogRecordLabelHandlerTests {

    @Test func callsGetRecordLabel() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogRecordLabelHandler.handle(
            services: container, options: GlobalOptions(), id: "rl.123", writer: writer
        )

        #expect(mock.getRecordLabelCalled)
    }

    @Test func returnsCorrectDTO() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getRecordLabelResult = .success(.fixture(id: "rl.42", name: "My Label"))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogRecordLabelHandler.handle(
            services: container, options: GlobalOptions(), id: "rl.42", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("My Label"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getRecordLabelResult = .failure(AuxError.notFound(message: "Record label not found"))

        await #expect(throws: AuxError.self) {
            try await CatalogRecordLabelHandler.handle(
                services: container, options: GlobalOptions(), id: "bad",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

//
//  CatalogChartsHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct CatalogChartsHandlerTests {

    @Test func callsGetCharts() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogChartsHandler.handle(
            services: container, options: GlobalOptions(),
            kinds: ["most-played"], types: ["songs"], genreId: nil, limit: 25,
            writer: writer
        )

        #expect(mock.getChartsCalled)
    }

    @Test func returnsCorrectResult() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getChartsResult = .success(ChartsResult(charts: [
            ChartEntry(title: "Top Songs", kind: "most-played", songs: [.fixture(title: "Hit Song")])
        ]))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogChartsHandler.handle(
            services: container, options: GlobalOptions(),
            kinds: ["most-played"], types: ["songs"], genreId: nil, limit: 25,
            writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("Top Songs"))
        #expect(json.contains("Hit Song"))
    }

    @Test func passesGenreIdToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getChartsResult = .success(ChartsResult(charts: []))

        let writer = JSONOutputWriter(destination: { _ in })
        try await CatalogChartsHandler.handle(
            services: container, options: GlobalOptions(),
            kinds: ["most-played"], types: ["songs"], genreId: "14", limit: 25,
            writer: writer
        )

        #expect(mock.getChartsCalled)
        #expect(mock.getChartsLastGenreId == "14")
    }

    @Test func passesNilGenreIdWhenNotSpecified() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getChartsResult = .success(ChartsResult(charts: []))

        let writer = JSONOutputWriter(destination: { _ in })
        try await CatalogChartsHandler.handle(
            services: container, options: GlobalOptions(),
            kinds: ["most-played"], types: ["songs"], genreId: nil, limit: 25,
            writer: writer
        )

        #expect(mock.getChartsLastGenreId == nil)
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getChartsResult = .failure(AuxError.networkError(message: "Network error"))

        await #expect(throws: AuxError.self) {
            try await CatalogChartsHandler.handle(
                services: container, options: GlobalOptions(),
                kinds: [], types: [], genreId: nil, limit: 25,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

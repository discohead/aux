//
//  CatalogStationDiscoveryHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation
import Testing
@testable import AuxKit

// MARK: - Helper

private let sampleStationsJSON = """
{
    "data": [
        {
            "id": "ra.123",
            "type": "stations",
            "attributes": {
                "name": "Test Station",
                "isLive": true,
                "artwork": {
                    "url": "https://example.com/art.jpg"
                },
                "url": "https://music.apple.com/station/123"
            }
        }
    ]
}
""".data(using: .utf8)!

private let sampleGenresJSON = """
{
    "data": [
        {
            "id": "sg.1",
            "type": "station-genres",
            "attributes": {
                "name": "Pop"
            }
        },
        {
            "id": "sg.2",
            "type": "station-genres",
            "attributes": {
                "name": "Rock"
            }
        }
    ]
}
""".data(using: .utf8)!

// MARK: - Personal Station Tests

struct CatalogPersonalStationHandlerTests {

    @Test func callsRESTAPI() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .success(sampleStationsJSON)
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogPersonalStationHandler.handle(
            services: container, options: GlobalOptions(), storefront: "us", writer: writer
        )

        #expect(mock.getCalled)
    }

    @Test func usesCorrectPath() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .success(sampleStationsJSON)
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogPersonalStationHandler.handle(
            services: container, options: GlobalOptions(), storefront: "us", writer: writer
        )

        #expect(mock.lastGetPath == "/v1/catalog/us/stations")
        #expect(mock.lastGetQueryParams?["filter[identity]"] == "personal")
    }

    @Test func parsesStationResponse() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .success(sampleStationsJSON)

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogPersonalStationHandler.handle(
            services: container, options: GlobalOptions(), storefront: "us", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("Test Station"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .failure(AuxError.networkError(message: "Network error"))

        await #expect(throws: AuxError.self) {
            try await CatalogPersonalStationHandler.handle(
                services: container, options: GlobalOptions(), storefront: "us",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - Live Stations Tests

struct CatalogLiveStationsHandlerTests {

    @Test func callsRESTAPI() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .success(sampleStationsJSON)
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogLiveStationsHandler.handle(
            services: container, options: GlobalOptions(), storefront: "us", writer: writer
        )

        #expect(mock.getCalled)
    }

    @Test func usesCorrectPathAndFilter() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .success(sampleStationsJSON)
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogLiveStationsHandler.handle(
            services: container, options: GlobalOptions(), storefront: "gb", limit: 10, writer: writer
        )

        #expect(mock.lastGetPath == "/v1/catalog/gb/stations")
        #expect(mock.lastGetQueryParams?["filter[featured]"] == "apple-music-live-radio")
        #expect(mock.lastGetQueryParams?["limit"] == "10")
    }

    @Test func defaultsLimitTo25() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .success(sampleStationsJSON)
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogLiveStationsHandler.handle(
            services: container, options: GlobalOptions(), storefront: "us", writer: writer
        )

        #expect(mock.lastGetQueryParams?["limit"] == "25")
    }
}

// MARK: - Station Genres Tests

struct CatalogStationGenresHandlerTests {

    @Test func callsRESTAPI() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .success(sampleGenresJSON)
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogStationGenresHandler.handle(
            services: container, options: GlobalOptions(), storefront: "us", writer: writer
        )

        #expect(mock.getCalled)
    }

    @Test func usesCorrectPath() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .success(sampleGenresJSON)
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogStationGenresHandler.handle(
            services: container, options: GlobalOptions(), storefront: "us", writer: writer
        )

        #expect(mock.lastGetPath == "/v1/catalog/us/station-genres")
    }

    @Test func parsesGenresResponse() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .success(sampleGenresJSON)

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await CatalogStationGenresHandler.handle(
            services: container, options: GlobalOptions(), storefront: "us", writer: writer
        )

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("Pop"))
        #expect(json.contains("Rock"))
    }
}

// MARK: - Stations For Genre Tests

struct CatalogStationsForGenreHandlerTests {

    @Test func callsRESTAPI() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .success(sampleStationsJSON)
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogStationsForGenreHandler.handle(
            services: container, options: GlobalOptions(), storefront: "us", genreId: "sg.1", writer: writer
        )

        #expect(mock.getCalled)
    }

    @Test func usesCorrectPath() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .success(sampleStationsJSON)
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogStationsForGenreHandler.handle(
            services: container, options: GlobalOptions(), storefront: "us", genreId: "sg.1", limit: 15, writer: writer
        )

        #expect(mock.lastGetPath == "/v1/catalog/us/station-genres/sg.1/stations")
        #expect(mock.lastGetQueryParams?["limit"] == "15")
    }

    @Test func defaultsLimitTo25() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .success(sampleStationsJSON)
        let writer = JSONOutputWriter(destination: { _ in })

        try await CatalogStationsForGenreHandler.handle(
            services: container, options: GlobalOptions(), storefront: "us", genreId: "sg.1", writer: writer
        )

        #expect(mock.lastGetQueryParams?["limit"] == "25")
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.getResult = .failure(AuxError.networkError(message: "Timeout"))

        await #expect(throws: AuxError.self) {
            try await CatalogStationsForGenreHandler.handle(
                services: container, options: GlobalOptions(), storefront: "us", genreId: "sg.1",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

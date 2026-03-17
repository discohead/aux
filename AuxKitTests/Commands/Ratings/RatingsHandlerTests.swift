import Foundation
import Testing
@testable import AuxKit

// MARK: - RatingsGetHandler Tests

struct RatingsGetHandlerTests {
    @Test func callsRESTAPIGet() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        try await RatingsGetHandler.handle(
            services: container, options: GlobalOptions(),
            type: "songs", id: "123",
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getCalled)
    }

    @Test func returnsRatingResultWithId() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await RatingsGetHandler.handle(
            services: container, options: GlobalOptions(),
            type: "songs", id: "456", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"456\""))
        #expect(json.contains("\"data\""))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.restAPI as! MockRESTAPIService).getResult = .failure(AuxError.networkError(message: "offline"))

        await #expect(throws: AuxError.self) {
            try await RatingsGetHandler.handle(
                services: container, options: GlobalOptions(),
                type: "songs", id: "123",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - RatingsSetHandler Tests

struct RatingsSetHandlerTests {
    @Test func callsRESTAPIPut() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        try await RatingsSetHandler.handle(
            services: container, options: GlobalOptions(),
            type: "albums", id: "789", rating: 5,
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.putCalled)
    }

    @Test func returnsRatingResultWithRatingValue() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await RatingsSetHandler.handle(
            services: container, options: GlobalOptions(),
            type: "songs", id: "101", rating: 3, writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"101\""))
        #expect(json.contains("3"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.restAPI as! MockRESTAPIService).putResult = .failure(AuxError.networkError(message: "timeout"))

        await #expect(throws: AuxError.self) {
            try await RatingsSetHandler.handle(
                services: container, options: GlobalOptions(),
                type: "songs", id: "123", rating: 5,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - RatingsDeleteHandler Tests

struct RatingsDeleteHandlerTests {
    @Test func callsRESTAPIDelete() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        try await RatingsDeleteHandler.handle(
            services: container, options: GlobalOptions(),
            type: "songs", id: "555",
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.deleteCalled)
    }

    @Test func returnsRatingResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await RatingsDeleteHandler.handle(
            services: container, options: GlobalOptions(),
            type: "playlists", id: "999", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"999\""))
        #expect(json.contains("\"data\""))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.restAPI as! MockRESTAPIService).deleteResult = .failure(AuxError.notFound(message: "not found"))

        await #expect(throws: AuxError.self) {
            try await RatingsDeleteHandler.handle(
                services: container, options: GlobalOptions(),
                type: "songs", id: "123",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

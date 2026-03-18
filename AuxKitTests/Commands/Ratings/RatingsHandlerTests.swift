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

    @Test func parsesRatingValueFromResponse() async throws {
        let container = ServiceContainer.mock()
        let mockResponse = """
        {"data":[{"id":"456","type":"ratings","attributes":{"value":1}}]}
        """
        (container.restAPI as! MockRESTAPIService).getResult = .success(Data(mockResponse.utf8))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await RatingsGetHandler.handle(
            services: container, options: GlobalOptions(),
            type: "songs", id: "456", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"rating\":1"))
    }

    @Test func rejectsInvalidType() async throws {
        let container = ServiceContainer.mock()

        await #expect(throws: AuxError.self) {
            try await RatingsGetHandler.handle(
                services: container, options: GlobalOptions(),
                type: "invalid-type", id: "123",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
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

// MARK: - RatingsGetHandler Library Tests

struct RatingsGetHandlerLibraryTests {
    @Test func usesLibraryRatingsPath() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        try await RatingsGetHandler.handle(
            services: container, options: GlobalOptions(),
            type: "library-songs", id: "123", library: true,
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getCalled)
        #expect(mock.lastGetPath == "/v1/me/library-ratings/library-songs/123")
    }

    @Test func acceptsLibraryTypes() async throws {
        let container = ServiceContainer.mock()
        let writer = JSONOutputWriter(destination: { _ in })

        for type in ["library-songs", "library-albums", "library-playlists", "library-music-videos"] {
            try await RatingsGetHandler.handle(
                services: container, options: GlobalOptions(),
                type: type, id: "123", library: true, writer: writer
            )
        }
    }

    @Test func rejectsCatalogTypesWhenLibrary() async throws {
        let container = ServiceContainer.mock()

        await #expect(throws: AuxError.self) {
            try await RatingsGetHandler.handle(
                services: container, options: GlobalOptions(),
                type: "songs", id: "123", library: true,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func rejectsLibraryTypesWhenNotLibrary() async throws {
        let container = ServiceContainer.mock()

        await #expect(throws: AuxError.self) {
            try await RatingsGetHandler.handle(
                services: container, options: GlobalOptions(),
                type: "library-songs", id: "123", library: false,
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
            type: "albums", id: "789", rating: 1,
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
            type: "songs", id: "101", rating: 1, writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"101\""))
        #expect(json.contains("1"))
    }

    @Test func rejectsInvalidType() async throws {
        let container = ServiceContainer.mock()

        await #expect(throws: AuxError.self) {
            try await RatingsSetHandler.handle(
                services: container, options: GlobalOptions(),
                type: "invalid", id: "123", rating: 1,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func rejectsInvalidRatingValue() async throws {
        let container = ServiceContainer.mock()

        await #expect(throws: AuxError.self) {
            try await RatingsSetHandler.handle(
                services: container, options: GlobalOptions(),
                type: "songs", id: "123", rating: 5,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func acceptsValidRatingValues() async throws {
        let container = ServiceContainer.mock()
        let writer = JSONOutputWriter(destination: { _ in })

        for rating in [-1, 0, 1] {
            try await RatingsSetHandler.handle(
                services: container, options: GlobalOptions(),
                type: "songs", id: "123", rating: rating, writer: writer
            )
        }
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.restAPI as! MockRESTAPIService).putResult = .failure(AuxError.networkError(message: "timeout"))

        await #expect(throws: AuxError.self) {
            try await RatingsSetHandler.handle(
                services: container, options: GlobalOptions(),
                type: "songs", id: "123", rating: 1,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - RatingsSetHandler Library Tests

struct RatingsSetHandlerLibraryTests {
    @Test func usesLibraryRatingsPath() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        try await RatingsSetHandler.handle(
            services: container, options: GlobalOptions(),
            type: "library-albums", id: "456", rating: 1, library: true,
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.putCalled)
    }

    @Test func rejectsCatalogTypesWhenLibrary() async throws {
        let container = ServiceContainer.mock()

        await #expect(throws: AuxError.self) {
            try await RatingsSetHandler.handle(
                services: container, options: GlobalOptions(),
                type: "albums", id: "123", rating: 1, library: true,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func acceptsLibraryTypes() async throws {
        let container = ServiceContainer.mock()
        let writer = JSONOutputWriter(destination: { _ in })

        for type in ["library-songs", "library-albums", "library-playlists", "library-music-videos"] {
            try await RatingsSetHandler.handle(
                services: container, options: GlobalOptions(),
                type: type, id: "123", rating: 1, library: true, writer: writer
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

    @Test func rejectsInvalidType() async throws {
        let container = ServiceContainer.mock()

        await #expect(throws: AuxError.self) {
            try await RatingsDeleteHandler.handle(
                services: container, options: GlobalOptions(),
                type: "invalid", id: "123",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
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

// MARK: - RatingsDeleteHandler Library Tests

struct RatingsDeleteHandlerLibraryTests {
    @Test func usesLibraryRatingsPath() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        try await RatingsDeleteHandler.handle(
            services: container, options: GlobalOptions(),
            type: "library-songs", id: "789", library: true,
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.deleteCalled)
    }

    @Test func rejectsCatalogTypesWhenLibrary() async throws {
        let container = ServiceContainer.mock()

        await #expect(throws: AuxError.self) {
            try await RatingsDeleteHandler.handle(
                services: container, options: GlobalOptions(),
                type: "playlists", id: "123", library: true,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func acceptsLibraryTypes() async throws {
        let container = ServiceContainer.mock()
        let writer = JSONOutputWriter(destination: { _ in })

        for type in ["library-songs", "library-albums", "library-playlists", "library-music-videos"] {
            try await RatingsDeleteHandler.handle(
                services: container, options: GlobalOptions(),
                type: type, id: "123", library: true, writer: writer
            )
        }
    }
}

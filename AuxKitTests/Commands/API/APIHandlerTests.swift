import Foundation
import Testing
@testable import AuxKit

// MARK: - APIGetHandler Tests

struct APIGetHandlerTests {
    @Test func callsRESTAPIGet() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        try await APIGetHandler.handle(
            services: container, options: GlobalOptions(),
            path: "/v1/catalog/us/songs/123",
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getCalled)
    }

    @Test func returnsRawAPIResponse() async throws {
        let container = ServiceContainer.mock()
        (container.restAPI as! MockRESTAPIService).getResult = .success(Data("{\"id\":\"1\"}".utf8))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await APIGetHandler.handle(
            services: container, options: GlobalOptions(),
            path: "/v1/catalog/us/songs/1", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"status_code\""))
        #expect(json.contains("200"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.restAPI as! MockRESTAPIService).getResult = .failure(AuxError.networkError(message: "offline"))

        await #expect(throws: AuxError.self) {
            try await APIGetHandler.handle(
                services: container, options: GlobalOptions(),
                path: "/v1/catalog/us/songs/1",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - APIPostHandler Tests

struct APIPostHandlerTests {
    @Test func callsRESTAPIPost() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        try await APIPostHandler.handle(
            services: container, options: GlobalOptions(),
            path: "/v1/me/library",
            body: "{\"ids\":[\"1\"]}",
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.postCalled)
    }

    @Test func returnsRawAPIResponse() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await APIPostHandler.handle(
            services: container, options: GlobalOptions(),
            path: "/v1/me/library", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"body\""))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.restAPI as! MockRESTAPIService).postResult = .failure(AuxError.serviceError(message: "server error"))

        await #expect(throws: AuxError.self) {
            try await APIPostHandler.handle(
                services: container, options: GlobalOptions(),
                path: "/v1/me/library",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - APIPutHandler Tests

struct APIPutHandlerTests {
    @Test func callsRESTAPIPut() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        try await APIPutHandler.handle(
            services: container, options: GlobalOptions(),
            path: "/v1/me/ratings/songs/123",
            body: "{\"value\":5}",
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.putCalled)
    }

    @Test func returnsRawAPIResponse() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await APIPutHandler.handle(
            services: container, options: GlobalOptions(),
            path: "/v1/me/ratings/songs/123",
            body: "{\"value\":5}", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"status_code\""))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.restAPI as! MockRESTAPIService).putResult = .failure(AuxError.notAuthorized(message: "unauthorized"))

        await #expect(throws: AuxError.self) {
            try await APIPutHandler.handle(
                services: container, options: GlobalOptions(),
                path: "/v1/me/ratings/songs/123",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - APIDeleteHandler Tests

struct APIDeleteHandlerTests {
    @Test func callsRESTAPIDelete() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        try await APIDeleteHandler.handle(
            services: container, options: GlobalOptions(),
            path: "/v1/me/ratings/songs/123",
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.deleteCalled)
    }

    @Test func returnsRawAPIResponse() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await APIDeleteHandler.handle(
            services: container, options: GlobalOptions(),
            path: "/v1/me/ratings/songs/123", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"body\""))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.restAPI as! MockRESTAPIService).deleteResult = .failure(AuxError.notFound(message: "not found"))

        await #expect(throws: AuxError.self) {
            try await APIDeleteHandler.handle(
                services: container, options: GlobalOptions(),
                path: "/v1/me/ratings/songs/123",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

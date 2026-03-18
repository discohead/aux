import Foundation
import Testing
@testable import AuxKit

struct CatalogEquivalentHandlerTests {
    @Test func callsRESTAPIGet() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        try await CatalogEquivalentHandler.handle(
            services: container, options: GlobalOptions(),
            type: "songs", id: "123", storefront: "us",
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getCalled)
    }

    @Test func usesCorrectPathAndQueryParams() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        try await CatalogEquivalentHandler.handle(
            services: container, options: GlobalOptions(),
            type: "albums", id: "456", storefront: "gb",
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getCalled)
        #expect(mock.lastGetPath == "/v1/catalog/gb/albums")
        #expect(mock.lastGetQueryParams?["filter[equivalents]"] == "456")
    }

    @Test func returnsEquivalentResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await CatalogEquivalentHandler.handle(
            services: container, options: GlobalOptions(),
            type: "songs", id: "789", storefront: "jp",
            writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"type\""))
    }

    @Test func rejectsInvalidType() async throws {
        let container = ServiceContainer.mock()

        await #expect(throws: AuxError.self) {
            try await CatalogEquivalentHandler.handle(
                services: container, options: GlobalOptions(),
                type: "playlists", id: "123", storefront: "us",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func rejectsInvalidTypeWithMessage() async throws {
        let container = ServiceContainer.mock()

        do {
            try await CatalogEquivalentHandler.handle(
                services: container, options: GlobalOptions(),
                type: "artists", id: "123", storefront: "us",
                writer: JSONOutputWriter(destination: { _ in })
            )
            #expect(Bool(false), "Should have thrown")
        } catch let error as AuxError {
            let message = "\(error)"
            #expect(message.contains("Invalid type"))
        }
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.restAPI as! MockRESTAPIService).getResult = .failure(AuxError.networkError(message: "offline"))

        await #expect(throws: AuxError.self) {
            try await CatalogEquivalentHandler.handle(
                services: container, options: GlobalOptions(),
                type: "songs", id: "123", storefront: "us",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

import Foundation
import Testing
@testable import AuxKit

// MARK: - LibraryAddHandler Tests

struct LibraryAddHandlerTests {
    @Test func callsPostOnRESTService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryAddHandler.handle(
            services: container, options: GlobalOptions(),
            ids: ["1", "2"], type: "songs", writer: writer
        )
        #expect(mock.postCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsAddToLibraryResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryAddHandler.handle(
            services: container, options: GlobalOptions(),
            ids: ["1"], type: "albums", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"added\""))
        #expect(json.contains("\"data\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.postResult = .failure(AuxError.networkError(message: "offline"))

        await #expect(throws: AuxError.self) {
            try await LibraryAddHandler.handle(
                services: container, options: GlobalOptions(),
                ids: ["1"], type: "songs",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryCreatePlaylistHandler Tests

struct LibraryCreatePlaylistHandlerTests {
    @Test func callsPostOnRESTService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryCreatePlaylistHandler.handle(
            services: container, options: GlobalOptions(),
            name: "My Playlist", writer: writer
        )
        #expect(mock.postCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsCreatePlaylistResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryCreatePlaylistHandler.handle(
            services: container, options: GlobalOptions(),
            name: "Test Playlist", description: "A test", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"name\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.postResult = .failure(AuxError.networkError(message: "offline"))

        await #expect(throws: AuxError.self) {
            try await LibraryCreatePlaylistHandler.handle(
                services: container, options: GlobalOptions(),
                name: "Test",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryAddToPlaylistHandler Tests

struct LibraryAddToPlaylistHandlerTests {
    @Test func callsPostOnRESTService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryAddToPlaylistHandler.handle(
            services: container, options: GlobalOptions(),
            playlistId: "pl123", trackIds: ["1", "2"], writer: writer
        )
        #expect(mock.postCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryAddToPlaylistHandler.handle(
            services: container, options: GlobalOptions(),
            playlistId: "pl123", trackIds: ["1"], writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"success\""))
        #expect(json.contains("true"))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.restAPI as! MockRESTAPIService
        mock.postResult = .failure(AuxError.networkError(message: "offline"))

        await #expect(throws: AuxError.self) {
            try await LibraryAddToPlaylistHandler.handle(
                services: container, options: GlobalOptions(),
                playlistId: "pl123", trackIds: ["1"],
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

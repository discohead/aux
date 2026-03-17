import Foundation
import Testing
@testable import AuxKit

// MARK: - LibraryGetTagsHandler Tests

struct LibraryGetTagsHandlerTests {
    @Test func callsGetTrackTagsOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getTrackTagsResult = .success(.fixture())

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetTagsHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        #expect(mock.getTrackTagsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsTrackTagsInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getTrackTagsResult = .success(.fixture(name: "My Song"))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetTagsHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("My Song"))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getTrackTagsResult = .failure(AuxError.appleScriptError(message: "not found"))

        await #expect(throws: AuxError.self) {
            try await LibraryGetTagsHandler.handle(
                services: container, options: GlobalOptions(),
                trackId: 999, writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibrarySetTagsHandler Tests

struct LibrarySetTagsHandlerTests {
    @Test func callsSetTrackTagsOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibrarySetTagsHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, fields: ["artist": "New Artist"], writer: writer
        )
        #expect(mock.setTrackTagsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibrarySetTagsHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, fields: ["genre": "Rock"], writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"success\""))
        #expect(json.contains("true"))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.setTrackTagsResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibrarySetTagsHandler.handle(
                services: container, options: GlobalOptions(),
                trackId: 1, fields: ["artist": "X"],
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryBatchSetTagsHandler Tests

struct LibraryBatchSetTagsHandlerTests {
    @Test func callsBatchSetTrackTagsOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryBatchSetTagsHandler.handle(
            services: container, options: GlobalOptions(),
            trackIds: [1, 2, 3], fields: ["genre": "Jazz"], writer: writer
        )
        #expect(mock.batchSetTrackTagsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryBatchSetTagsHandler.handle(
            services: container, options: GlobalOptions(),
            trackIds: [1, 2], fields: ["genre": "Pop"], writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"success\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.batchSetTrackTagsResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryBatchSetTagsHandler.handle(
                services: container, options: GlobalOptions(),
                trackIds: [1], fields: ["artist": "X"],
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

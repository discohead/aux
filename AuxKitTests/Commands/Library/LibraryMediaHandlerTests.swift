import Foundation
import Testing
@testable import AuxKit

// MARK: - LibraryGetLyricsHandler Tests

struct LibraryGetLyricsHandlerTests {
    @Test func callsGetLyricsOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getLyricsResult = .success("Hello world")

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetLyricsHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        #expect(mock.getLyricsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsLyricsInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getLyricsResult = .success("Some lyrics")

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetLyricsHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"lyrics\""))
        #expect(json.contains("Some lyrics"))
    }

    @Test func handlesNilLyrics() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getLyricsResult = .success(nil)

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetLyricsHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        #expect(mock.getLyricsCalled)
        #expect(capturedData != nil)
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getLyricsResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryGetLyricsHandler.handle(
                services: container, options: GlobalOptions(),
                trackId: 1, writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibrarySetLyricsHandler Tests

struct LibrarySetLyricsHandlerTests {
    @Test func callsSetLyricsOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibrarySetLyricsHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, text: "New lyrics", writer: writer
        )
        #expect(mock.setLyricsCalled)
        #expect(capturedData != nil)
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.setLyricsResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibrarySetLyricsHandler.handle(
                services: container, options: GlobalOptions(),
                trackId: 1, text: "test",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryGetArtworkHandler Tests

struct LibraryGetArtworkHandlerTests {
    @Test func callsGetArtworkOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getArtworkResult = .success(ArtworkResult(databaseId: 1, artworkCount: 1))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetArtworkHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        #expect(mock.getArtworkCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsArtworkResultInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getArtworkResult = .success(ArtworkResult(databaseId: 1, artworkCount: 2, format: "JPEG"))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetArtworkHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"artwork_count\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getArtworkResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryGetArtworkHandler.handle(
                services: container, options: GlobalOptions(),
                trackId: 1, writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibrarySetArtworkHandler Tests

struct LibrarySetArtworkHandlerTests {
    @Test func callsSetArtworkOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibrarySetArtworkHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, imagePath: "/tmp/art.jpg", writer: writer
        )
        #expect(mock.setArtworkCalled)
        #expect(capturedData != nil)
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.setArtworkResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibrarySetArtworkHandler.handle(
                services: container, options: GlobalOptions(),
                trackId: 1, imagePath: "/tmp/art.jpg",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryGetArtworkCountHandler Tests

struct LibraryGetArtworkCountHandlerTests {
    @Test func callsGetArtworkCountOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getArtworkCountResult = .success(3)

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetArtworkCountHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        #expect(mock.getArtworkCountCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsCountInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getArtworkCountResult = .success(5)

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetArtworkCountHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"count\""))
        #expect(json.contains("5"))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getArtworkCountResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryGetArtworkCountHandler.handle(
                services: container, options: GlobalOptions(),
                trackId: 1, writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryGetFileInfoHandler Tests

struct LibraryGetFileInfoHandlerTests {
    @Test func callsGetFileInfoOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getFileInfoResult = .success(.fixture())

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetFileInfoHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        #expect(mock.getFileInfoCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsFileInfoInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getFileInfoResult = .success(.fixture(location: "/Music/song.mp3"))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetFileInfoHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getFileInfoResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryGetFileInfoHandler.handle(
                services: container, options: GlobalOptions(),
                trackId: 1, writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

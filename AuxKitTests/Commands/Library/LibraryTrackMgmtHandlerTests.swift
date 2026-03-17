import Foundation
import Testing
@testable import AuxKit

// MARK: - LibraryRevealHandler Tests

struct LibraryRevealHandlerTests {
    @Test func callsRevealOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.revealResult = .success("/Music/song.mp3")

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryRevealHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        #expect(mock.revealCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsRevealResultInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.revealResult = .success("/Music/song.mp3")

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryRevealHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"path\""))
        #expect(json.contains("song.mp3"))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.revealResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryRevealHandler.handle(
                services: container, options: GlobalOptions(),
                trackId: 1, writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryDeleteHandler Tests

struct LibraryDeleteHandlerTests {
    @Test func callsDeleteTracksOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryDeleteHandler.handle(
            services: container, options: GlobalOptions(),
            trackIds: [1, 2], writer: writer
        )
        #expect(mock.deleteTracksCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryDeleteHandler.handle(
            services: container, options: GlobalOptions(),
            trackIds: [1], writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"success\""))
        #expect(json.contains("true"))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.deleteTracksResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryDeleteHandler.handle(
                services: container, options: GlobalOptions(),
                trackIds: [1], writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryConvertHandler Tests

struct LibraryConvertHandlerTests {
    @Test func callsConvertTracksOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryConvertHandler.handle(
            services: container, options: GlobalOptions(),
            trackIds: [1], writer: writer
        )
        #expect(mock.convertTracksCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsConvertResultInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.convertTracksResult = .success(ConvertResult(converted: true, tracks: []))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryConvertHandler.handle(
            services: container, options: GlobalOptions(),
            trackIds: [1], writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"converted\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.convertTracksResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryConvertHandler.handle(
                services: container, options: GlobalOptions(),
                trackIds: [1], writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryImportHandler Tests

struct LibraryImportHandlerTests {
    @Test func callsImportFilesOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryImportHandler.handle(
            services: container, options: GlobalOptions(),
            paths: ["/tmp/song.mp3"], writer: writer
        )
        #expect(mock.importFilesCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsImportResultInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.importFilesResult = .success(ImportResult(imported: true, fileCount: 1))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryImportHandler.handle(
            services: container, options: GlobalOptions(),
            paths: ["/tmp/song.mp3"], writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"imported\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.importFilesResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryImportHandler.handle(
                services: container, options: GlobalOptions(),
                paths: ["/tmp/song.mp3"],
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryGetPlayStatsHandler Tests

struct LibraryGetPlayStatsHandlerTests {
    @Test func callsGetPlayStatsOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getPlayStatsResult = .success(.fixture())

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetPlayStatsHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        #expect(mock.getPlayStatsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsPlayStatsInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getPlayStatsResult = .success(.fixture(playedCount: 42))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryGetPlayStatsHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("42"))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getPlayStatsResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryGetPlayStatsHandler.handle(
                services: container, options: GlobalOptions(),
                trackId: 1, writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibrarySetPlayStatsHandler Tests

struct LibrarySetPlayStatsHandlerTests {
    @Test func callsSetPlayStatsOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibrarySetPlayStatsHandler.handle(
            services: container, options: GlobalOptions(),
            trackId: 1, fields: ["played_count": "10"], writer: writer
        )
        #expect(mock.setPlayStatsCalled)
        #expect(capturedData != nil)
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.setPlayStatsResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibrarySetPlayStatsHandler.handle(
                services: container, options: GlobalOptions(),
                trackId: 1, fields: ["played_count": "10"],
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryResetPlayStatsHandler Tests

struct LibraryResetPlayStatsHandlerTests {
    @Test func callsResetPlayStatsOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryResetPlayStatsHandler.handle(
            services: container, options: GlobalOptions(),
            trackIds: [1, 2], writer: writer
        )
        #expect(mock.resetPlayStatsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryResetPlayStatsHandler.handle(
            services: container, options: GlobalOptions(),
            trackIds: [1], writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"success\""))
        #expect(json.contains("true"))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.resetPlayStatsResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryResetPlayStatsHandler.handle(
                services: container, options: GlobalOptions(),
                trackIds: [1], writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

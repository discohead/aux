import Foundation
import Testing
@testable import AuxKit

// MARK: - LibraryListPlaylistsHandler Tests

struct LibraryListPlaylistsHandlerTests {
    @Test func callsListAllPlaylistsOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.listAllPlaylistsResult = .success([
            PlaylistInfoResult(id: "1", name: "Favorites", trackCount: 10)
        ])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryListPlaylistsHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        #expect(mock.listAllPlaylistsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsPlaylistsInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.listAllPlaylistsResult = .success([
            PlaylistInfoResult(id: "1", name: "Favorites")
        ])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryListPlaylistsHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("Favorites"))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.listAllPlaylistsResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryListPlaylistsHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryDeletePlaylistHandler Tests

struct LibraryDeletePlaylistHandlerTests {
    @Test func callsDeletePlaylistOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryDeletePlaylistHandler.handle(
            services: container, options: GlobalOptions(),
            name: "Old Playlist", writer: writer
        )
        #expect(mock.deletePlaylistCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryDeletePlaylistHandler.handle(
            services: container, options: GlobalOptions(),
            name: "Old Playlist", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"success\""))
        #expect(json.contains("true"))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.deletePlaylistResult = .failure(AuxError.appleScriptError(message: "not found"))

        await #expect(throws: AuxError.self) {
            try await LibraryDeletePlaylistHandler.handle(
                services: container, options: GlobalOptions(),
                name: "Missing", writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryRenamePlaylistHandler Tests

struct LibraryRenamePlaylistHandlerTests {
    @Test func callsRenamePlaylistOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryRenamePlaylistHandler.handle(
            services: container, options: GlobalOptions(),
            name: "Old", newName: "New", writer: writer
        )
        #expect(mock.renamePlaylistCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryRenamePlaylistHandler.handle(
            services: container, options: GlobalOptions(),
            name: "Old", newName: "New", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"success\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.renamePlaylistResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryRenamePlaylistHandler.handle(
                services: container, options: GlobalOptions(),
                name: "Old", newName: "New",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryRemoveFromPlaylistHandler Tests

struct LibraryRemoveFromPlaylistHandlerTests {
    @Test func callsRemoveTracksFromPlaylistOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryRemoveFromPlaylistHandler.handle(
            services: container, options: GlobalOptions(),
            playlistName: "My Playlist", trackIds: [1, 2], writer: writer
        )
        #expect(mock.removeTracksFromPlaylistCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryRemoveFromPlaylistHandler.handle(
            services: container, options: GlobalOptions(),
            playlistName: "My Playlist", trackIds: [1], writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"success\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.removeTracksFromPlaylistResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryRemoveFromPlaylistHandler.handle(
                services: container, options: GlobalOptions(),
                playlistName: "My Playlist", trackIds: [1],
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryReorderTracksHandler Tests

struct LibraryReorderTracksHandlerTests {
    @Test func callsReorderPlaylistTracksOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryReorderTracksHandler.handle(
            services: container, options: GlobalOptions(),
            playlistName: "My Playlist", trackIds: [3, 1, 2], writer: writer
        )
        #expect(mock.reorderPlaylistTracksCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryReorderTracksHandler.handle(
            services: container, options: GlobalOptions(),
            playlistName: "My Playlist", trackIds: [3, 1, 2], writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"success\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.reorderPlaylistTracksResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryReorderTracksHandler.handle(
                services: container, options: GlobalOptions(),
                playlistName: "My Playlist", trackIds: [1],
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryFindDuplicatesHandler Tests

struct LibraryFindDuplicatesHandlerTests {
    @Test func callsFindDuplicatesInPlaylistOnAppleScript() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.findDuplicatesInPlaylistResult = .success([.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryFindDuplicatesHandler.handle(
            services: container, options: GlobalOptions(),
            playlistName: "My Playlist", writer: writer
        )
        #expect(mock.findDuplicatesInPlaylistCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsDuplicatesInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.findDuplicatesInPlaylistResult = .success([
            .fixture(id: "1", title: "Dup Song"),
            .fixture(id: "2", title: "Dup Song")
        ])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryFindDuplicatesHandler.handle(
            services: container, options: GlobalOptions(),
            playlistName: "My Playlist", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("Dup Song"))
    }

    @Test func returnsEmptyArrayWhenNoDuplicates() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.findDuplicatesInPlaylistResult = .success([])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryFindDuplicatesHandler.handle(
            services: container, options: GlobalOptions(),
            playlistName: "My Playlist", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("[]"))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.findDuplicatesInPlaylistResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryFindDuplicatesHandler.handle(
                services: container, options: GlobalOptions(),
                playlistName: "My Playlist",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

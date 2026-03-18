import Foundation
import Testing
@testable import AuxKit

// MARK: - LibrarySongsHandler Tests

struct LibrarySongsHandlerTests {
    @Test func callsGetSongsOnLibraryService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getSongsResult = .success([.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibrarySongsHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        #expect(mock.getSongsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsResultsInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        let songs = [SongDTO.fixture(id: "1"), SongDTO.fixture(id: "2")]
        mock.getSongsResult = .success(songs)

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibrarySongsHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"meta\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getSongsResult = .failure(AuxError.serviceError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibrarySongsHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func passesSortToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getSongsResult = .success([])

        let writer = JSONOutputWriter(destination: { _ in })
        try await LibrarySongsHandler.handle(
            services: container, options: GlobalOptions(),
            sort: "play-count", writer: writer
        )
        #expect(mock.getSongsCalled)
        #expect(mock.getSongsLastSort == "play-count")
    }

    @Test func passesDescendingPlayCountSort() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getSongsResult = .success([])

        let writer = JSONOutputWriter(destination: { _ in })
        try await LibrarySongsHandler.handle(
            services: container, options: GlobalOptions(),
            sort: "-play-count", writer: writer
        )
        #expect(mock.getSongsCalled)
        #expect(mock.getSongsLastSort == "-play-count")
    }

    @Test func passesFiltersToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getSongsResult = .success([])

        let writer = JSONOutputWriter(destination: { _ in })
        try await LibrarySongsHandler.handle(
            services: container, options: GlobalOptions(),
            title: "Test", artist: "Artist", album: "Album",
            downloadedOnly: true, writer: writer
        )
        #expect(mock.getSongsCalled)
    }

    @Test func allPagesFetchesAllItems() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getSongsResult = .success([.fixture(id: "1"), .fixture(id: "2")])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        // With allPages=true, pageSize=25 and mock returning 2 items (< 25), stops after 1 call
        try await LibrarySongsHandler.handle(
            services: container, options: GlobalOptions(),
            limit: 25, allPages: true, writer: writer
        )
        #expect(mock.getSongsCalled)
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
    }

    @Test func allPagesFalseUsesStandardPagination() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getSongsResult = .success([.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibrarySongsHandler.handle(
            services: container, options: GlobalOptions(),
            allPages: false, writer: writer
        )
        #expect(mock.getSongsCalled)
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"has_next\""))
    }
}

// MARK: - LibraryAlbumsHandler Tests

struct LibraryAlbumsHandlerTests {
    @Test func callsGetAlbumsOnLibraryService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getAlbumsResult = .success([.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryAlbumsHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        #expect(mock.getAlbumsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsResultsWithPagination() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getAlbumsResult = .success([.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryAlbumsHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"meta\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getAlbumsResult = .failure(AuxError.serviceError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryAlbumsHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryArtistsHandler Tests

struct LibraryArtistsHandlerTests {
    @Test func callsGetArtistsOnLibraryService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getArtistsResult = .success([.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryArtistsHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        #expect(mock.getArtistsCalled)
        #expect(capturedData != nil)
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getArtistsResult = .failure(AuxError.serviceError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryArtistsHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryPlaylistsHandler Tests

struct LibraryPlaylistsHandlerTests {
    @Test func callsGetPlaylistsOnLibraryService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getPlaylistsResult = .success([.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryPlaylistsHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        #expect(mock.getPlaylistsCalled)
        #expect(capturedData != nil)
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getPlaylistsResult = .failure(AuxError.serviceError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryPlaylistsHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibraryMusicVideosHandler Tests

struct LibraryMusicVideosHandlerTests {
    @Test func callsGetMusicVideosOnLibraryService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getMusicVideosResult = .success([.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibraryMusicVideosHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        #expect(mock.getMusicVideosCalled)
        #expect(capturedData != nil)
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.getMusicVideosResult = .failure(AuxError.serviceError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibraryMusicVideosHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

// MARK: - LibrarySearchHandler Tests

struct LibrarySearchHandlerTests {
    @Test func callsSearchOnLibraryService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.searchResult = .success(LibrarySearchResult(songs: [.fixture()]))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibrarySearchHandler.handle(
            services: container, options: GlobalOptions(),
            query: "test", writer: writer
        )
        #expect(mock.searchCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsResultsInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.searchResult = .success(LibrarySearchResult(songs: [.fixture()]))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await LibrarySearchHandler.handle(
            services: container, options: GlobalOptions(),
            query: "test", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.library as! MockMusicLibraryService
        mock.searchResult = .failure(AuxError.serviceError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await LibrarySearchHandler.handle(
                services: container, options: GlobalOptions(),
                query: "test", writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

import Foundation
import Testing
@testable import AuxKit

struct SearchSongsHandlerTests {
    @Test func callsSearchSongsOnCatalogService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.searchSongsResult = .success([.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await SearchSongsHandler.handle(
            services: container, options: GlobalOptions(),
            query: "test", writer: writer
        )
        #expect(mock.searchSongsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsResultsInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let songs = [SongDTO.fixture(id: "1"), SongDTO.fixture(id: "2")]
        mock.searchSongsResult = .success(songs)

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await SearchSongsHandler.handle(
            services: container, options: GlobalOptions(),
            query: "test", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"meta\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.searchSongsResult = .failure(AuxError.networkError(message: "offline"))

        await #expect(throws: AuxError.self) {
            try await SearchSongsHandler.handle(
                services: container, options: GlobalOptions(),
                query: "test", writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func rejectsLimitAbove25() async throws {
        let container = ServiceContainer.mock()
        await #expect(throws: AuxError.self) {
            try await SearchSongsHandler.handle(
                services: container, options: GlobalOptions(),
                query: "test", limit: 1000,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func rejectsLimitBelow1() async throws {
        let container = ServiceContainer.mock()
        await #expect(throws: AuxError.self) {
            try await SearchSongsHandler.handle(
                services: container, options: GlobalOptions(),
                query: "test", limit: 0,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

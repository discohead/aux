import Foundation
import Testing
@testable import AuxKit

struct SearchAlbumsHandlerTests {
    @Test func callsSearchAlbumsOnCatalogService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.searchAlbumsResult = .success([.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await SearchAlbumsHandler.handle(
            services: container, options: GlobalOptions(),
            query: "test", writer: writer
        )
        #expect(mock.searchAlbumsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsResultsInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let albums = [AlbumDTO.fixture(id: "1"), AlbumDTO.fixture(id: "2")]
        mock.searchAlbumsResult = .success(albums)

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await SearchAlbumsHandler.handle(
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
        mock.searchAlbumsResult = .failure(AuxError.networkError(message: "offline"))

        await #expect(throws: AuxError.self) {
            try await SearchAlbumsHandler.handle(
                services: container, options: GlobalOptions(),
                query: "test", writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

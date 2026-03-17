import Foundation
import Testing
@testable import AuxKit

struct SearchMusicVideosHandlerTests {
    @Test func callsSearchMusicVideosOnCatalogService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.searchMusicVideosResult = .success([.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await SearchMusicVideosHandler.handle(
            services: container, options: GlobalOptions(),
            query: "test", writer: writer
        )
        #expect(mock.searchMusicVideosCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsResultsInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let videos = [MusicVideoDTO.fixture(id: "1"), MusicVideoDTO.fixture(id: "2")]
        mock.searchMusicVideosResult = .success(videos)

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await SearchMusicVideosHandler.handle(
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
        mock.searchMusicVideosResult = .failure(AuxError.networkError(message: "offline"))

        await #expect(throws: AuxError.self) {
            try await SearchMusicVideosHandler.handle(
                services: container, options: GlobalOptions(),
                query: "test", writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

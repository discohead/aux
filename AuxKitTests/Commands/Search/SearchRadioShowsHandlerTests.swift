import Foundation
import Testing
@testable import AuxKit

struct SearchRadioShowsHandlerTests {
    @Test func callsSearchRadioShowsOnCatalogService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.searchRadioShowsResult = .success([.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await SearchRadioShowsHandler.handle(
            services: container, options: GlobalOptions(),
            query: "test", writer: writer
        )
        #expect(mock.searchRadioShowsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsResultsInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        let shows = [RadioShowDTO.fixture(id: "1"), RadioShowDTO.fixture(id: "2")]
        mock.searchRadioShowsResult = .success(shows)

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await SearchRadioShowsHandler.handle(
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
        mock.searchRadioShowsResult = .failure(AuxError.networkError(message: "offline"))

        await #expect(throws: AuxError.self) {
            try await SearchRadioShowsHandler.handle(
                services: container, options: GlobalOptions(),
                query: "test", writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

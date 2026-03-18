import Foundation
import Testing
@testable import AuxKit

struct RecentlyPlayedStationsHandlerTests {

    @Test func callsHistoryService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.history as! MockHistoryService

        try await RecentlyPlayedStationsHandler.handle(
            services: container, options: GlobalOptions(),
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getRecentlyPlayedStationsCalled)
    }

    @Test func writesStationsWithPaginationMeta() async throws {
        let container = ServiceContainer.mock()
        let mock = container.history as! MockHistoryService
        mock.getRecentlyPlayedStationsResult = .success([StationDTO.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await RecentlyPlayedStationsHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"meta\""))
    }

    @Test func passesLimitToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.history as! MockHistoryService

        try await RecentlyPlayedStationsHandler.handle(
            services: container, options: GlobalOptions(),
            limit: 10, writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getRecentlyPlayedStationsCalled)
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.history as! MockHistoryService).getRecentlyPlayedStationsResult = .failure(
            AuxError.networkError(message: "offline")
        )

        await #expect(throws: AuxError.self) {
            try await RecentlyPlayedStationsHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

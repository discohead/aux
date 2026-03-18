import Foundation
import Testing
@testable import AuxKit

struct RecentlyAddedHandlerTests {

    @Test func callsHistoryService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.history as! MockHistoryService

        try await RecentlyAddedHandler.handle(
            services: container, options: GlobalOptions(),
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getRecentlyAddedResourcesCalled)
    }

    @Test func writesResultWithPaginationMeta() async throws {
        let container = ServiceContainer.mock()
        let mock = container.history as! MockHistoryService
        mock.getRecentlyAddedResourcesResult = .success(
            RecentlyAddedResult(items: [RecentlyAddedItem.fixture()])
        )

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await RecentlyAddedHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"meta\""))
        #expect(json.contains("\"items\""))
    }

    @Test func passesLimitToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.history as! MockHistoryService

        try await RecentlyAddedHandler.handle(
            services: container, options: GlobalOptions(),
            limit: 15, writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getRecentlyAddedResourcesCalled)
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.history as! MockHistoryService).getRecentlyAddedResourcesResult = .failure(
            AuxError.networkError(message: "offline")
        )

        await #expect(throws: AuxError.self) {
            try await RecentlyAddedHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

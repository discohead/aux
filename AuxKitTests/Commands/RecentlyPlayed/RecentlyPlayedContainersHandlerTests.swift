import Foundation
import Testing
@testable import AuxKit

struct RecentlyPlayedContainersHandlerTests {
    @Test func callsGetRecentlyPlayedContainers() async throws {
        let container = ServiceContainer.mock()
        let mock = container.recentlyPlayed as! MockRecentlyPlayedService

        try await RecentlyPlayedContainersHandler.handle(
            services: container, options: GlobalOptions(),
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getRecentlyPlayedContainersCalled)
    }

    @Test func returnsContainersInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.recentlyPlayed as! MockRecentlyPlayedService
        mock.getRecentlyPlayedContainersResult = .success(
            RecentlyPlayedContainersResult(items: [
                RecentlyPlayedContainer(type: "album", id: "a1", name: "Test Album")
            ])
        )

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await RecentlyPlayedContainersHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"items\""))
    }

    @Test func passesLimitToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.recentlyPlayed as! MockRecentlyPlayedService

        try await RecentlyPlayedContainersHandler.handle(
            services: container, options: GlobalOptions(),
            limit: 5, writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getRecentlyPlayedContainersCalled)
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.recentlyPlayed as! MockRecentlyPlayedService
        mock.getRecentlyPlayedContainersResult = .failure(AuxError.notAuthorized(message: "denied"))

        await #expect(throws: AuxError.self) {
            try await RecentlyPlayedContainersHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

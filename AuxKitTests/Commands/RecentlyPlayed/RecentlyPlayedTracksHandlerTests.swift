import Foundation
import Testing
@testable import AuxKit

struct RecentlyPlayedTracksHandlerTests {
    @Test func callsGetRecentlyPlayedTracks() async throws {
        let container = ServiceContainer.mock()
        let mock = container.recentlyPlayed as! MockRecentlyPlayedService

        try await RecentlyPlayedTracksHandler.handle(
            services: container, options: GlobalOptions(),
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getRecentlyPlayedTracksCalled)
    }

    @Test func returnsTracksInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.recentlyPlayed as! MockRecentlyPlayedService
        mock.getRecentlyPlayedTracksResult = .success([TrackDTO.fixture()])

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await RecentlyPlayedTracksHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"song\""))
    }

    @Test func passesLimitToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.recentlyPlayed as! MockRecentlyPlayedService

        try await RecentlyPlayedTracksHandler.handle(
            services: container, options: GlobalOptions(),
            limit: 15, writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getRecentlyPlayedTracksCalled)
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.recentlyPlayed as! MockRecentlyPlayedService
        mock.getRecentlyPlayedTracksResult = .failure(AuxError.notAuthorized(message: "denied"))

        await #expect(throws: AuxError.self) {
            try await RecentlyPlayedTracksHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

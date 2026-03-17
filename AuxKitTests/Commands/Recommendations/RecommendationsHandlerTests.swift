import Foundation
import Testing
@testable import AuxKit

struct RecommendationsHandlerTests {
    @Test func callsGetRecommendations() async throws {
        let container = ServiceContainer.mock()
        let mock = container.recommendations as! MockRecommendationsService

        try await RecommendationsHandler.handle(
            services: container, options: GlobalOptions(),
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getRecommendationsCalled)
    }

    @Test func returnsResultInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.recommendations as! MockRecommendationsService
        mock.getRecommendationsResult = .success(
            RecommendationsResult(recommendations: [
                RecommendationGroup(title: "For You", types: ["playlists"])
            ])
        )

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await RecommendationsHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"recommendations\""))
    }

    @Test func passesLimitToService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.recommendations as! MockRecommendationsService

        try await RecommendationsHandler.handle(
            services: container, options: GlobalOptions(),
            limit: 5, writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.getRecommendationsCalled)
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.recommendations as! MockRecommendationsService
        mock.getRecommendationsResult = .failure(AuxError.notAuthorized(message: "denied"))

        await #expect(throws: AuxError.self) {
            try await RecommendationsHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

import Foundation
import Testing
@testable import AuxKit

struct SearchSuggestionsHandlerTests {
    @Test func callsGetSuggestionsOnCatalogService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getSuggestionsResult = .success(SuggestionsResult(terms: ["test suggestion"]))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await SearchSuggestionsHandler.handle(
            services: container, options: GlobalOptions(),
            query: "test", writer: writer
        )
        #expect(mock.getSuggestionsCalled)
        #expect(capturedData != nil)
    }

    @Test func returnsResultsInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getSuggestionsResult = .success(SuggestionsResult(terms: ["foo", "bar"]))

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await SearchSuggestionsHandler.handle(
            services: container, options: GlobalOptions(),
            query: "test", limit: 5, types: ["songs"], writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"terms\""))
    }

    @Test func propagatesServiceErrors() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getSuggestionsResult = .failure(AuxError.networkError(message: "offline"))

        await #expect(throws: AuxError.self) {
            try await SearchSuggestionsHandler.handle(
                services: container, options: GlobalOptions(),
                query: "test", writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

import Foundation
import Testing
@testable import AuxKit

struct FavoritesAddHandlerTests {

    @Test func callsFavoritesService() async throws {
        let container = ServiceContainer.mock()
        let mock = container.favorites as! MockFavoritesService

        try await FavoritesAddHandler.handle(
            services: container, options: GlobalOptions(),
            type: "songs", id: "123",
            writer: JSONOutputWriter(destination: { _ in })
        )
        #expect(mock.addFavoriteCalled)
    }

    @Test func writesResultInEnvelope() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(pretty: false, destination: { capturedData = $0 })

        try await FavoritesAddHandler.handle(
            services: container, options: GlobalOptions(),
            type: "songs", id: "456", writer: writer
        )
        let json = String(data: capturedData!, encoding: .utf8)!
        #expect(json.contains("\"data\""))
        #expect(json.contains("\"added\""))
    }

    @Test func rejectsInvalidType() async throws {
        let container = ServiceContainer.mock()

        await #expect(throws: AuxError.self) {
            try await FavoritesAddHandler.handle(
                services: container, options: GlobalOptions(),
                type: "invalid-type", id: "123",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func acceptsAllValidTypes() async throws {
        let container = ServiceContainer.mock()
        let writer = JSONOutputWriter(destination: { _ in })

        for type in ["songs", "albums", "playlists", "artists", "music-videos", "stations"] {
            try await FavoritesAddHandler.handle(
                services: container, options: GlobalOptions(),
                type: type, id: "123", writer: writer
            )
        }
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.favorites as! MockFavoritesService).addFavoriteResult = .failure(
            AuxError.networkError(message: "offline")
        )

        await #expect(throws: AuxError.self) {
            try await FavoritesAddHandler.handle(
                services: container, options: GlobalOptions(),
                type: "songs", id: "123",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

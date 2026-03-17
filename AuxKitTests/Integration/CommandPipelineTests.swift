//
//  CommandPipelineTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

/// Thread-safe data capture helper for tests.
private final class DataCapture: @unchecked Sendable {
    var data: Data?
}

struct CommandPipelineTests {

    // MARK: - Handler -> Envelope -> JSON Roundtrip

    @Test func authStatusProducesValidJSON() async throws {
        let container = ServiceContainer.mock()
        let capture = DataCapture()
        let writer = JSONOutputWriter(destination: { capture.data = $0 })

        try await AuthStatusHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capture.data)
        let parsed = try JSONSerialization.jsonObject(with: data)
        let json = try #require(parsed as? [String: Any])
        #expect(json["data"] != nil)
        let authData = try #require(json["data"] as? [String: Any])
        #expect(authData["authorization_status"] as? String == "authorized")
    }

    @Test func searchSongsProducesValidJSON() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.searchSongsResult = .success([.fixture(id: "1", title: "Hello")])

        let capture = DataCapture()
        let writer = JSONOutputWriter(destination: { capture.data = $0 })

        try await SearchSongsHandler.handle(
            services: container, options: GlobalOptions(),
            query: "test", writer: writer
        )

        let data = try #require(capture.data)
        let parsed = try JSONSerialization.jsonObject(with: data)
        let json = try #require(parsed as? [String: Any])
        let songs = try #require(json["data"] as? [[String: Any]])
        #expect(songs.count == 1)
        #expect(songs[0]["title"] as? String == "Hello")
    }

    @Test func catalogSongProducesValidJSON() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService
        mock.getSongResult = .success(.fixture(id: "42", title: "My Song", artistName: "Artist"))

        let capture = DataCapture()
        let writer = JSONOutputWriter(destination: { capture.data = $0 })

        try await CatalogSongHandler.handle(
            services: container, options: GlobalOptions(),
            id: "42", writer: writer
        )

        let data = try #require(capture.data)
        let parsed = try JSONSerialization.jsonObject(with: data)
        let json = try #require(parsed as? [String: Any])
        let song = try #require(json["data"] as? [String: Any])
        #expect(song["title"] as? String == "My Song")
        #expect(song["artist_name"] as? String == "Artist")
    }

    @Test func playbackPlayProducesValidJSON() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.playResult = .success(.fixture(title: "Now Playing", state: "playing"))

        let capture = DataCapture()
        let writer = JSONOutputWriter(destination: { capture.data = $0 })

        try await PlayHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capture.data)
        let parsed = try JSONSerialization.jsonObject(with: data)
        let json = try #require(parsed as? [String: Any])
        let np = try #require(json["data"] as? [String: Any])
        #expect(np["title"] as? String == "Now Playing")
        #expect(np["state"] as? String == "playing")
    }

    @Test func recommendationsProducesValidJSON() async throws {
        let container = ServiceContainer.mock()
        let capture = DataCapture()
        let writer = JSONOutputWriter(destination: { capture.data = $0 })

        try await RecommendationsHandler.handle(
            services: container, options: GlobalOptions(), writer: writer
        )

        let data = try #require(capture.data)
        let parsed = try JSONSerialization.jsonObject(with: data)
        let json = try #require(parsed as? [String: Any])
        #expect(json["data"] != nil)
    }

    // MARK: - Error -> CLIErrorResponse -> Exit Code Pipeline

    @Test func notFoundErrorProducesCorrectCode() {
        let error = AuxError.notFound(message: "Song not found")
        let response = error.toCLIErrorResponse()
        #expect(response.error.code == "not_found")
        #expect(response.error.message == "Song not found")
        #expect(error.exitCode == .notFound)
        #expect(error.exitCode.rawValue == 4)
    }

    @Test func networkErrorProducesCorrectCode() {
        let error = AuxError.networkError(message: "Offline")
        let response = error.toCLIErrorResponse()
        #expect(response.error.code == "network_error")
        #expect(error.exitCode == .networkError)
    }

    @Test func notAuthorizedErrorProducesCorrectCode() {
        let error = AuxError.notAuthorized(message: "Denied")
        let response = error.toCLIErrorResponse()
        #expect(response.error.code == "not_authorized")
        #expect(error.exitCode == .notAuthorized)
    }

    @Test func allErrorCodesHaveUniqueExitCodes() {
        let errors: [AuxError] = [
            .notAuthorized(message: ""),
            .notFound(message: ""),
            .networkError(message: ""),
            .serviceError(message: ""),
            .subscriptionRequired(message: ""),
            .unavailable(message: ""),
            .generalFailure(message: ""),
            .usageError(message: ""),
            .appleScriptError(message: ""),
        ]
        var seenCodes = Set<String>()
        for error in errors {
            let code = error.code
            #expect(!seenCodes.contains(code), "Duplicate error code: \(code)")
            seenCodes.insert(code)
        }
    }

    // MARK: - Fixture Validity Tests

    @Test func songFixtureProducesValidJSON() throws {
        let song = SongDTO.fixture()
        let envelope = OutputEnvelope(data: song)
        let data = try JSONEncoder().encode(envelope)
        let parsed = try JSONSerialization.jsonObject(with: data)
        let json = try #require(parsed as? [String: Any])
        #expect(json["data"] != nil)
    }

    @Test func albumFixtureProducesValidJSON() throws {
        let album = AlbumDTO.fixture()
        let envelope = OutputEnvelope(data: album)
        let data = try JSONEncoder().encode(envelope)
        let parsed = try JSONSerialization.jsonObject(with: data)
        let json = try #require(parsed as? [String: Any])
        #expect(json["data"] != nil)
    }

    @Test func nowPlayingFixtureProducesValidJSON() throws {
        let np = NowPlayingDTO.fixture()
        let envelope = OutputEnvelope(data: np)
        let data = try JSONEncoder().encode(envelope)
        let parsed = try JSONSerialization.jsonObject(with: data)
        let json = try #require(parsed as? [String: Any])
        let npData = try #require(json["data"] as? [String: Any])
        #expect(npData["title"] as? String == "Test Song")
    }

    // MARK: - Cross-group Integration

    @Test func searchThenCatalogLookup() async throws {
        let container = ServiceContainer.mock()
        let mock = container.catalog as! MockMusicCatalogService

        // Search returns a song
        mock.searchSongsResult = .success([.fixture(id: "42", title: "Found Song")])

        let searchCapture = DataCapture()
        let searchWriter = JSONOutputWriter(destination: { searchCapture.data = $0 })
        try await SearchSongsHandler.handle(
            services: container, options: GlobalOptions(),
            query: "found", writer: searchWriter
        )

        // Parse the search result to get the ID
        let searchData = try #require(searchCapture.data)
        let searchParsed = try JSONSerialization.jsonObject(with: searchData)
        let searchJSON = try #require(searchParsed as? [String: Any])
        let songs = try #require(searchJSON["data"] as? [[String: Any]])
        let songId = try #require(songs[0]["id"] as? String)

        // Catalog lookup with that ID
        mock.getSongResult = .success(.fixture(id: songId, title: "Found Song Details"))
        let catalogCapture = DataCapture()
        let catalogWriter = JSONOutputWriter(destination: { catalogCapture.data = $0 })
        try await CatalogSongHandler.handle(
            services: container, options: GlobalOptions(),
            id: songId, writer: catalogWriter
        )

        let catalogData = try #require(catalogCapture.data)
        let catalogParsed = try JSONSerialization.jsonObject(with: catalogData)
        let catalogJSON = try #require(catalogParsed as? [String: Any])
        let detail = try #require(catalogJSON["data"] as? [String: Any])
        #expect(detail["id"] as? String == "42")
    }

    @Test func prettyPrintProducesPrettyJSON() async throws {
        let container = ServiceContainer.mock()
        let capture = DataCapture()
        let writer = JSONOutputWriter(pretty: true, destination: { capture.data = $0 })

        try await AuthStatusHandler.handle(services: container, options: GlobalOptions(pretty: true), writer: writer)

        let data = try #require(capture.data)
        let json = try #require(String(data: data, encoding: .utf8))
        // Pretty-printed JSON should contain newlines
        #expect(json.contains("\n"))
    }
}

//
//  PlayHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct PlayHandlerTests {

    @Test func callsPlayOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await PlayHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        #expect(mock.playCalled)
    }

    @Test func passesTrackIdToPlay() async throws {
        let container = ServiceContainer.mock()
        let writer = JSONOutputWriter(destination: { _ in })

        try await PlayHandler.handle(services: container, options: GlobalOptions(), trackId: 42, writer: writer)

        let mock = container.appleScript as! MockAppleScriptBridge
        #expect(mock.playCalled)
    }

    @Test func returnsNowPlayingInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let expected = NowPlayingDTO.fixture(title: "My Song")
        (container.appleScript as! MockAppleScriptBridge).playResult = .success(expected)

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await PlayHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("My Song"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).playResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await PlayHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

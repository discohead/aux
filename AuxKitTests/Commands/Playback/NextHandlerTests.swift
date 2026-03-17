//
//  NextHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct NextHandlerTests {

    @Test func callsNextTrackOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await NextHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        #expect(mock.nextTrackCalled)
    }

    @Test func returnsNowPlayingInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let expected = NowPlayingDTO.fixture(title: "Next Song")
        (container.appleScript as! MockAppleScriptBridge).nextTrackResult = .success(expected)

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await NextHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("Next Song"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).nextTrackResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await NextHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

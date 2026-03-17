//
//  PreviousHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct PreviousHandlerTests {

    @Test func callsPreviousTrackOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await PreviousHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        #expect(mock.previousTrackCalled)
    }

    @Test func returnsNowPlayingInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let expected = NowPlayingDTO.fixture(title: "Previous Song")
        (container.appleScript as! MockAppleScriptBridge).previousTrackResult = .success(expected)

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await PreviousHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("Previous Song"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).previousTrackResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await PreviousHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

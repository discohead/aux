//
//  PlayerStatusHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct PlayerStatusHandlerTests {

    @Test func callsGetPlayerStatusOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await PlayerStatusHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        #expect(mock.getPlayerStatusCalled)
    }

    @Test func returnsPlayerStatusInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let expected = PlayerStatusResult(state: "playing", shuffleMode: "songs", repeatMode: "all", volume: 75.0)
        (container.appleScript as! MockAppleScriptBridge).getPlayerStatusResult = .success(expected)

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await PlayerStatusHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["state"] as? String == "playing")
        #expect(dataObj["shuffle_mode"] as? String == "songs")
        #expect(dataObj["repeat_mode"] as? String == "all")
        #expect(dataObj["volume"] as? Double == 75.0)
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).getPlayerStatusResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await PlayerStatusHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

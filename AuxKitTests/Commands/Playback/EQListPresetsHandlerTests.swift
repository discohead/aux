//
//  EQListPresetsHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct EQListPresetsHandlerTests {

    @Test func callsListEQPresetsOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await EQListPresetsHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        #expect(mock.listEQPresetsCalled)
    }

    @Test func returnsPresetsInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let presets = ["Flat", "Bass Booster", "Rock", "Jazz"]
        (container.appleScript as! MockAppleScriptBridge).listEQPresetsResult = .success(presets)

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await EQListPresetsHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("Flat"))
        #expect(json.contains("Bass Booster"))
        #expect(json.contains("Rock"))
        #expect(json.contains("Jazz"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).listEQPresetsResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await EQListPresetsHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

//
//  ShuffleHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct ShuffleHandlerTests {

    @Test func callsSetShuffleOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await ShuffleHandler.handle(services: container, options: GlobalOptions(), enabled: true, writer: writer)

        #expect(mock.setShuffleCalled)
    }

    @Test func returnsSuccessResultWhenEnabled() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await ShuffleHandler.handle(services: container, options: GlobalOptions(), enabled: true, writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["success"] as? Bool == true)
        #expect(dataObj["message"] as? String == "Shuffle enabled")
    }

    @Test func returnsSuccessResultWhenDisabled() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await ShuffleHandler.handle(services: container, options: GlobalOptions(), enabled: false, writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["message"] as? String == "Shuffle disabled")
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).setShuffleResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await ShuffleHandler.handle(
                services: container, options: GlobalOptions(), enabled: true,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

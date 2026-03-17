//
//  EQGetHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct EQGetHandlerTests {

    @Test func callsGetEQOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await EQGetHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        #expect(mock.getEQCalled)
    }

    @Test func returnsPresetWithEnabledTrue() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).getEQResult = .success("Rock")

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await EQGetHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["preset"] as? String == "Rock")
        #expect(dataObj["enabled"] as? Bool == true)
    }

    @Test func returnsDisabledWithNullPreset() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).getEQResult = .success(nil)

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await EQGetHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["enabled"] as? Bool == false)
        // preset should be explicitly null (NSNull)
        #expect(dataObj["preset"] is NSNull)
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).getEQResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await EQGetHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

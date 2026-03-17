//
//  EQSetHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct EQSetHandlerTests {

    @Test func callsSetEQOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await EQSetHandler.handle(services: container, options: options(), preset: "Rock", writer: writer)

        #expect(mock.setEQCalled)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await EQSetHandler.handle(services: container, options: options(), preset: "Jazz", writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["success"] as? Bool == true)
        #expect(dataObj["message"] as? String == "EQ preset set to Jazz")
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).setEQResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await EQSetHandler.handle(
                services: container, options: options(), preset: "Bad",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    private func options() -> GlobalOptions {
        GlobalOptions(pretty: false, quiet: true)
    }
}

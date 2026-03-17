//
//  RepeatHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct RepeatHandlerTests {

    @Test func callsSetRepeatOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await RepeatHandler.handle(services: container, options: GlobalOptions(), mode: "all", writer: writer)

        #expect(mock.setRepeatCalled)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await RepeatHandler.handle(services: container, options: GlobalOptions(), mode: "one", writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["success"] as? Bool == true)
        #expect(dataObj["message"] as? String == "Repeat mode set to one")
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).setRepeatResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await RepeatHandler.handle(
                services: container, options: GlobalOptions(), mode: "all",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

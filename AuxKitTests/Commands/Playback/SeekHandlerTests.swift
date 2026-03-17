//
//  SeekHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct SeekHandlerTests {

    @Test func callsSeekOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await SeekHandler.handle(services: container, options: GlobalOptions(), position: 30.0, writer: writer)

        #expect(mock.seekCalled)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await SeekHandler.handle(services: container, options: GlobalOptions(), position: 45.5, writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["success"] as? Bool == true)
        let message = dataObj["message"] as? String ?? ""
        #expect(message.contains("45.5"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).seekResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await SeekHandler.handle(
                services: container, options: GlobalOptions(), position: 10.0,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

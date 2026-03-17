//
//  PlayNextHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation
import Testing
@testable import AuxKit

struct PlayNextHandlerTests {

    @Test func callsPlayNextOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await PlayNextHandler.handle(services: container, options: options(), trackId: 42, writer: writer)

        #expect(mock.playNextCalled)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await PlayNextHandler.handle(services: container, options: options(), trackId: 42, writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["success"] as? Bool == true)
        #expect((dataObj["message"] as? String)?.contains("Play Next") == true)
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).playNextResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await PlayNextHandler.handle(
                services: container, options: options(), trackId: 42,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    private func options() -> GlobalOptions {
        GlobalOptions(pretty: false, quiet: true)
    }
}

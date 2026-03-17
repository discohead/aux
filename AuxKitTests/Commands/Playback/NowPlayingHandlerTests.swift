//
//  NowPlayingHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct NowPlayingHandlerTests {

    @Test func callsGetNowPlayingOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await NowPlayingHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        #expect(mock.getNowPlayingCalled)
    }

    @Test func returnsNowPlayingInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let expected = NowPlayingDTO.fixture(title: "Current Song", artistName: "Current Artist")
        (container.appleScript as! MockAppleScriptBridge).getNowPlayingResult = .success(expected)

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await NowPlayingHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("Current Song"))
        #expect(json.contains("Current Artist"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).getNowPlayingResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await NowPlayingHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

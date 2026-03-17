//
//  FastForwardHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct FastForwardHandlerTests {

    @Test func callsGetNowPlayingAndSeek() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getNowPlayingResult = .success(.fixture(positionSeconds: 30.0))
        let writer = JSONOutputWriter(destination: { _ in })

        try await FastForwardHandler.handle(services: container, options: GlobalOptions(), seconds: 10.0, writer: writer)

        #expect(mock.getNowPlayingCalled)
        #expect(mock.seekCalled)
    }

    @Test func calculatesCorrectPosition() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getNowPlayingResult = .success(.fixture(positionSeconds: 20.0))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await FastForwardHandler.handle(services: container, options: GlobalOptions(), seconds: 15.0, writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        let message = dataObj["message"] as? String ?? ""
        #expect(message.contains("35.0"))
    }

    @Test func handlesNilPosition() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        mock.getNowPlayingResult = .success(.fixture(positionSeconds: nil))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await FastForwardHandler.handle(services: container, options: GlobalOptions(), seconds: 10.0, writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        let message = dataObj["message"] as? String ?? ""
        #expect(message.contains("10.0"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).getNowPlayingResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await FastForwardHandler.handle(
                services: container, options: GlobalOptions(), seconds: 10.0,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

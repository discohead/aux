//
//  VolumeHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct VolumeHandlerTests {

    @Test func callsSetVolumeOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await VolumeHandler.handle(services: container, options: GlobalOptions(), volume: 50.0, writer: writer)

        #expect(mock.setVolumeCalled)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await VolumeHandler.handle(services: container, options: GlobalOptions(), volume: 75.0, writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["success"] as? Bool == true)
        let message = dataObj["message"] as? String ?? ""
        #expect(message.contains("75"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).setVolumeResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await VolumeHandler.handle(
                services: container, options: GlobalOptions(), volume: 50.0,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func rejectsVolumeAbove100() async throws {
        let container = ServiceContainer.mock()
        await #expect(throws: AuxError.self) {
            try await VolumeHandler.handle(
                services: container, options: GlobalOptions(), volume: 999.0,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func rejectsNegativeVolume() async throws {
        let container = ServiceContainer.mock()
        await #expect(throws: AuxError.self) {
            try await VolumeHandler.handle(
                services: container, options: GlobalOptions(), volume: -1.0,
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }

    @Test func acceptsBoundaryVolumes() async throws {
        let container = ServiceContainer.mock()
        let writer = JSONOutputWriter(destination: { _ in })

        try await VolumeHandler.handle(services: container, options: GlobalOptions(), volume: 0.0, writer: writer)
        try await VolumeHandler.handle(services: container, options: GlobalOptions(), volume: 100.0, writer: writer)
    }
}

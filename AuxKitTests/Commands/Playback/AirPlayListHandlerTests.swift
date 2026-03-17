//
//  AirPlayListHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct AirPlayListHandlerTests {

    @Test func callsListAirPlayDevicesOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await AirPlayListHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        #expect(mock.listAirPlayDevicesCalled)
    }

    @Test func returnsDevicesInEnvelope() async throws {
        let container = ServiceContainer.mock()
        let devices = [
            AirPlayDevice(name: "Living Room", kind: "AppleTV", active: true),
            AirPlayDevice(name: "Bedroom", kind: "HomePod", active: false),
        ]
        (container.appleScript as! MockAppleScriptBridge).listAirPlayDevicesResult = .success(AirPlayDeviceResult(devices: devices))

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await AirPlayListHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capturedData)
        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("Living Room"))
        #expect(json.contains("Bedroom"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).listAirPlayDevicesResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await AirPlayListHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

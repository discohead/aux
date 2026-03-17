//
//  AirPlayCurrentHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct AirPlayCurrentHandlerTests {

    @Test func callsGetCurrentAirPlayDeviceOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await AirPlayCurrentHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        #expect(mock.getCurrentAirPlayDeviceCalled)
    }

    @Test func returnsDeviceNameInEnvelope() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).getCurrentAirPlayDeviceResult = .success("Living Room")

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await AirPlayCurrentHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["device"] as? String == "Living Room")
    }

    @Test func returnsNullDeviceWhenNone() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).getCurrentAirPlayDeviceResult = .success(nil)

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await AirPlayCurrentHandler.handle(services: container, options: GlobalOptions(), writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        // device should not have a String value when nil
        #expect(dataObj["device"] as? String == nil)
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).getCurrentAirPlayDeviceResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await AirPlayCurrentHandler.handle(
                services: container, options: GlobalOptions(),
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

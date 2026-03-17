//
//  AirPlaySelectHandlerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct AirPlaySelectHandlerTests {

    @Test func callsSelectAirPlayDeviceOnAppleScriptBridge() async throws {
        let container = ServiceContainer.mock()
        let mock = container.appleScript as! MockAppleScriptBridge
        let writer = JSONOutputWriter(destination: { _ in })

        try await AirPlaySelectHandler.handle(services: container, options: GlobalOptions(), name: "Living Room", writer: writer)

        #expect(mock.selectAirPlayDeviceCalled)
    }

    @Test func returnsSuccessResult() async throws {
        let container = ServiceContainer.mock()

        var capturedData: Data?
        let writer = JSONOutputWriter(destination: { capturedData = $0 })

        try await AirPlaySelectHandler.handle(services: container, options: GlobalOptions(), name: "Kitchen", writer: writer)

        let data = try #require(capturedData)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let dataObj = json["data"] as! [String: Any]
        #expect(dataObj["success"] as? Bool == true)
        let message = dataObj["message"] as? String ?? ""
        #expect(message.contains("Kitchen"))
    }

    @Test func propagatesErrors() async throws {
        let container = ServiceContainer.mock()
        (container.appleScript as! MockAppleScriptBridge).selectAirPlayDeviceResult = .failure(AuxError.appleScriptError(message: "fail"))

        await #expect(throws: AuxError.self) {
            try await AirPlaySelectHandler.handle(
                services: container, options: GlobalOptions(), name: "Bad Device",
                writer: JSONOutputWriter(destination: { _ in })
            )
        }
    }
}

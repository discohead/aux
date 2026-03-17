//
//  AirPlaySelectHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `playback airplay-select` command — selects an AirPlay device.
public struct AirPlaySelectHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        name: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.selectAirPlayDevice(name: name)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: SuccessResult(message: "Selected AirPlay device: \(name)")))
    }
}

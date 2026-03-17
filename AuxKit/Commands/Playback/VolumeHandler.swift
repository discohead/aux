//
//  VolumeHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `playback volume` command — sets the player volume.
public struct VolumeHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        volume: Double,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        guard volume >= 0, volume <= 100 else {
            throw AuxError.usageError(message: "Volume must be between 0 and 100 (got \(Int(volume)))")
        }
        try await services.appleScript.setVolume(volume)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: SuccessResult(message: "Volume set to \(Int(volume))")))
    }
}

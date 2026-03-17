//
//  ShuffleHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `playback shuffle` command — enables or disables shuffle mode.
public struct ShuffleHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        enabled: Bool,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.setShuffle(enabled)
        let outputWriter = writer ?? options.makeOutputWriter()
        let state = enabled ? "enabled" : "disabled"
        try outputWriter.write(OutputEnvelope(data: SuccessResult(message: "Shuffle \(state)")))
    }
}

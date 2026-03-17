//
//  EQSetHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `playback eq-set` command — sets the EQ preset.
public struct EQSetHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        preset: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.setEQ(preset: preset)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: SuccessResult(message: "EQ preset set to \(preset)")))
    }
}

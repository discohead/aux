//
//  StopHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `playback stop` command — stops playback.
public struct StopHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.stop()
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: SuccessResult(message: "Playback stopped")))
    }
}

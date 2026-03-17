//
//  RepeatHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `playback repeat` command — sets the repeat mode.
public struct RepeatHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        mode: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.setRepeat(mode)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: SuccessResult(message: "Repeat mode set to \(mode)")))
    }
}

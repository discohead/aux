//
//  SeekHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `playback seek` command — seeks to a position in seconds.
public struct SeekHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        position: Double,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.seek(position: position)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: SuccessResult(message: "Seeked to \(position) seconds")))
    }
}

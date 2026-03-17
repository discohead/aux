//
//  PlayHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `playback play` command — starts or resumes playback.
public struct PlayHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int? = nil,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.appleScript.play(trackId: trackId)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

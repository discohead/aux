//
//  RewindHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `playback rewind` command — skips backward by a number of seconds.
public struct RewindHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        seconds: Double,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let nowPlaying = try await services.appleScript.getNowPlaying()
        let currentPosition = nowPlaying.positionSeconds ?? 0.0
        let newPosition = max(0.0, currentPosition - seconds)
        try await services.appleScript.seek(position: newPosition)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: SuccessResult(message: "Rewound \(seconds) seconds to \(newPosition)")))
    }
}

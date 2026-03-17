//
//  PlayNextHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Handler for the `playback play-next` command — adds a track as next in queue via GUI scripting.
public struct PlayNextHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.playNext(trackId: trackId)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: SuccessResult(message: "Play Next: track \(trackId)")))
    }
}

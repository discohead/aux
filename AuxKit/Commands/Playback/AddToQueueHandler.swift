//
//  AddToQueueHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Handler for the `playback add-to-queue` command — appends a track to the queue via GUI scripting.
public struct AddToQueueHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.addToQueue(trackId: trackId)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: SuccessResult(message: "Add to Queue: track \(trackId)")))
    }
}

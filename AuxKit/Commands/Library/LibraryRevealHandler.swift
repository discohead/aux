//
//  LibraryRevealHandler.swift
//  AuxKit
//

import Foundation

/// Handler for revealing a track's file in Finder via AppleScript.
public struct LibraryRevealHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let path = try await services.appleScript.reveal(trackId: trackId)
        let result = RevealResult(trackId: trackId, path: path)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

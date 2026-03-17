//
//  LibraryGetLyricsHandler.swift
//  AuxKit
//

import Foundation

/// Handler for getting track lyrics via AppleScript.
public struct LibraryGetLyricsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let lyrics = try await services.appleScript.getLyrics(trackId: trackId)
        let result = LyricsResult(trackId: trackId, lyrics: lyrics)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

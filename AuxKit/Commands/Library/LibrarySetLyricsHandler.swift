//
//  LibrarySetLyricsHandler.swift
//  AuxKit
//

import Foundation

/// Handler for setting track lyrics via AppleScript.
public struct LibrarySetLyricsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        text: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.setLyrics(trackId: trackId, text: text)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: LibraryActionResult(message: "Lyrics updated for track \(trackId)")))
    }
}

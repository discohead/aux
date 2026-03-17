//
//  LibrarySetPlayStatsHandler.swift
//  AuxKit
//

import Foundation

/// Handler for setting track play statistics via AppleScript.
public struct LibrarySetPlayStatsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        fields: [String: String],
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.setPlayStats(trackId: trackId, fields: fields)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: LibraryActionResult(message: "Play stats updated for track \(trackId)")))
    }
}

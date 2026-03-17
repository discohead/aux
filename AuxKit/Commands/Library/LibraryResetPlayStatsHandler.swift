//
//  LibraryResetPlayStatsHandler.swift
//  AuxKit
//

import Foundation

/// Handler for resetting track play statistics via AppleScript.
public struct LibraryResetPlayStatsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackIds: [Int],
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.resetPlayStats(trackIds: trackIds)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: LibraryActionResult(message: "Play stats reset for \(trackIds.count) track(s)")))
    }
}

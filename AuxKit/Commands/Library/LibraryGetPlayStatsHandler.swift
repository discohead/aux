//
//  LibraryGetPlayStatsHandler.swift
//  AuxKit
//

import Foundation

/// Handler for getting track play statistics via AppleScript.
public struct LibraryGetPlayStatsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.appleScript.getPlayStats(trackId: trackId)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

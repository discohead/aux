//
//  LibraryGetArtworkCountHandler.swift
//  AuxKit
//

import Foundation

/// Handler for getting track artwork count via AppleScript.
public struct LibraryGetArtworkCountHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let count = try await services.appleScript.getArtworkCount(trackId: trackId)
        let result = ArtworkCountResult(trackId: trackId, count: count)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

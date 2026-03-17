//
//  LibraryGetArtworkHandler.swift
//  AuxKit
//

import Foundation

/// Handler for getting track artwork via AppleScript.
public struct LibraryGetArtworkHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        index: Int = 1,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.appleScript.getArtwork(trackId: trackId, index: index)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

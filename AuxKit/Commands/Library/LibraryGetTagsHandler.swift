//
//  LibraryGetTagsHandler.swift
//  AuxKit
//

import Foundation

/// Handler for getting track tags via AppleScript.
public struct LibraryGetTagsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.appleScript.getTrackTags(trackId: trackId)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

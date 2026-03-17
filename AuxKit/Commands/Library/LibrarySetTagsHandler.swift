//
//  LibrarySetTagsHandler.swift
//  AuxKit
//

import Foundation

/// Handler for setting track tags via AppleScript.
public struct LibrarySetTagsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        fields: [String: String],
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.setTrackTags(trackId: trackId, fields: fields)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: LibraryActionResult(message: "Tags updated for track \(trackId)")))
    }
}

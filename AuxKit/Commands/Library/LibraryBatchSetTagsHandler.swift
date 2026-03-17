//
//  LibraryBatchSetTagsHandler.swift
//  AuxKit
//

import Foundation

/// Handler for batch setting track tags via AppleScript.
public struct LibraryBatchSetTagsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackIds: [Int],
        fields: [String: String],
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.batchSetTrackTags(trackIds: trackIds, fields: fields)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: LibraryActionResult(message: "Tags updated for \(trackIds.count) track(s)")))
    }
}

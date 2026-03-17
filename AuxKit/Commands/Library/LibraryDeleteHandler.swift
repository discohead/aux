//
//  LibraryDeleteHandler.swift
//  AuxKit
//

import Foundation

/// Handler for deleting tracks from the library via AppleScript.
public struct LibraryDeleteHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackIds: [Int],
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.deleteTracks(trackIds: trackIds)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: LibraryActionResult(message: "Deleted \(trackIds.count) track(s)")))
    }
}

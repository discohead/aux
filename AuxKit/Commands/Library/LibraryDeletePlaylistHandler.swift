//
//  LibraryDeletePlaylistHandler.swift
//  AuxKit
//

import Foundation

/// Handler for deleting a playlist via AppleScript.
public struct LibraryDeletePlaylistHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        name: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.deletePlaylist(name: name)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: LibraryActionResult(message: "Deleted playlist '\(name)'")))
    }
}

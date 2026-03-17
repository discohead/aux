//
//  LibraryRenamePlaylistHandler.swift
//  AuxKit
//

import Foundation

/// Handler for renaming a playlist via AppleScript.
public struct LibraryRenamePlaylistHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        name: String,
        newName: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.renamePlaylist(name: name, newName: newName)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: LibraryActionResult(message: "Renamed playlist '\(name)' to '\(newName)'")))
    }
}

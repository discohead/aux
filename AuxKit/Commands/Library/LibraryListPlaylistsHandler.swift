//
//  LibraryListPlaylistsHandler.swift
//  AuxKit
//

import Foundation

/// Handler for listing all playlists via AppleScript.
public struct LibraryListPlaylistsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let results = try await services.appleScript.listAllPlaylists()
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: results))
    }
}

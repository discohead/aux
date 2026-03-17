//
//  LibraryFindDuplicatesHandler.swift
//  AuxKit
//

import Foundation

/// Handler for finding duplicate tracks in a playlist via AppleScript.
public struct LibraryFindDuplicatesHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        playlistName: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let results = try await services.appleScript.findDuplicatesInPlaylist(playlistName: playlistName)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: results))
    }
}

//
//  LibraryReorderTracksHandler.swift
//  AuxKit
//

import Foundation

/// Handler for reordering tracks in a playlist via AppleScript.
public struct LibraryReorderTracksHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        playlistName: String,
        trackIds: [Int],
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.reorderPlaylistTracks(playlistName: playlistName, trackIds: trackIds)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: LibraryActionResult(message: "Reordered tracks in playlist '\(playlistName)'")))
    }
}

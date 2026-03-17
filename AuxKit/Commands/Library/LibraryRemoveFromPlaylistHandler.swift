//
//  LibraryRemoveFromPlaylistHandler.swift
//  AuxKit
//

import Foundation

/// Handler for removing tracks from a playlist via AppleScript.
public struct LibraryRemoveFromPlaylistHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        playlistName: String,
        trackIds: [Int],
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.removeTracksFromPlaylist(playlistName: playlistName, trackIds: trackIds)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: LibraryActionResult(message: "Removed \(trackIds.count) track(s) from playlist '\(playlistName)'")))
    }
}

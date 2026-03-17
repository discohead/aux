//
//  LibraryAddToPlaylistHandler.swift
//  AuxKit
//

import Foundation

/// Handler for adding tracks to an existing playlist via REST API.
public struct LibraryAddToPlaylistHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        playlistId: String,
        trackIds: [String],
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let trackData = trackIds.map { ["id": $0, "type": "songs"] }
        let body: [String: Any] = ["data": trackData]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        _ = try await services.restAPI.post(path: "/v1/me/library/playlists/\(playlistId)/tracks", body: bodyData)
        let result = LibraryActionResult(success: true, message: "Added \(trackIds.count) track(s) to playlist")
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

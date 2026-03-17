//
//  LibraryCreatePlaylistHandler.swift
//  AuxKit
//

import Foundation

/// Handler for creating a new playlist in the user's library via REST API.
public struct LibraryCreatePlaylistHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        name: String,
        description: String? = nil,
        trackIds: [String] = [],
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        var attributes: [String: Any] = ["name": name]
        if let description = description {
            attributes["description"] = description
        }
        var body: [String: Any] = ["attributes": attributes]
        if !trackIds.isEmpty {
            let trackData = trackIds.map { ["id": $0, "type": "songs"] }
            body["relationships"] = ["tracks": ["data": trackData]]
        }
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        let responseData = try await services.restAPI.post(path: "/v1/me/library/playlists", body: bodyData)
        let decoder = JSONDecoder()
        if let result = try? decoder.decode(CreatePlaylistResult.self, from: responseData) {
            let outputWriter = writer ?? options.makeOutputWriter()
            try outputWriter.write(OutputEnvelope(data: result))
        } else {
            let result = CreatePlaylistResult(id: "new", name: name, description: description)
            let outputWriter = writer ?? options.makeOutputWriter()
            try outputWriter.write(OutputEnvelope(data: result))
        }
    }
}

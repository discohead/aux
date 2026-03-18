//
//  RatingsSetHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `ratings set` command — sets a rating for an item.
public struct RatingsSetHandler {

    /// Valid Apple Music API resource types for catalog ratings.
    static let catalogTypes = ["songs", "albums", "playlists", "music-videos", "stations"]

    /// Valid Apple Music API resource types for library ratings.
    static let libraryTypes = ["library-songs", "library-albums", "library-playlists", "library-music-videos"]

    /// Legacy accessor for backward compatibility.
    static let validTypes = catalogTypes

    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        type: String,
        id: String,
        rating: Int,
        library: Bool = false,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let activeTypes = library ? libraryTypes : catalogTypes
        guard activeTypes.contains(type) else {
            throw AuxError.usageError(
                message: "Invalid type '\(type)'. Valid types: \(activeTypes.joined(separator: ", "))"
            )
        }
        guard rating >= -1, rating <= 1 else {
            throw AuxError.usageError(
                message: "Rating must be -1 (dislike), 0 (neutral), or 1 (like). Got \(rating)"
            )
        }

        let basePath = library ? "/v1/me/library-ratings" : "/v1/me/ratings"
        let path = "\(basePath)/\(type)/\(id)"
        // Apple Music API requires this specific body format for PUT ratings
        let bodyDict: [String: Any] = [
            "type": "rating",
            "attributes": ["value": rating]
        ]
        let body = try JSONSerialization.data(withJSONObject: bodyDict)
        let _ = try await services.restAPI.put(path: path, body: body)
        let result = RatingResult(updated: true, id: id, rating: rating)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

//
//  RatingsGetHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `ratings get` command — retrieves a rating for an item.
public struct RatingsGetHandler {

    /// Valid Apple Music API resource types for ratings.
    static let validTypes = ["songs", "albums", "playlists", "music-videos", "stations"]

    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        type: String,
        id: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        guard validTypes.contains(type) else {
            throw AuxError.usageError(
                message: "Invalid type '\(type)'. Valid types: \(validTypes.joined(separator: ", "))"
            )
        }

        let path = "/v1/me/ratings/\(type)/\(id)"
        let data = try await services.restAPI.get(path: path, queryParams: nil)

        // Parse the rating value from the Apple Music API response
        var ratingValue: Int? = nil
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let dataArray = json["data"] as? [[String: Any]],
           let first = dataArray.first,
           let attributes = first["attributes"] as? [String: Any],
           let value = attributes["value"] as? Int {
            ratingValue = value
        }

        let result = RatingResult(updated: true, id: id, rating: ratingValue)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

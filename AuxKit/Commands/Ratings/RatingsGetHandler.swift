//
//  RatingsGetHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `ratings get` command — retrieves a rating for an item.
public struct RatingsGetHandler {

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
        library: Bool = false,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let activeTypes = library ? libraryTypes : catalogTypes
        guard activeTypes.contains(type) else {
            throw AuxError.usageError(
                message: "Invalid type '\(type)'. Valid types: \(activeTypes.joined(separator: ", "))"
            )
        }

        let basePath = library ? "/v1/me/library-ratings" : "/v1/me/ratings"
        let path = "\(basePath)/\(type)/\(id)"
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

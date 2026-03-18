//
//  RatingsDeleteHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `ratings delete` command — removes a rating for an item.
public struct RatingsDeleteHandler {

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
        let _ = try await services.restAPI.delete(path: path)
        let result = RatingResult(updated: true, id: id)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

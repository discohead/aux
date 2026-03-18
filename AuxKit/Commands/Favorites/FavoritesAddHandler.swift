//
//  FavoritesAddHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Handler for the `favorites add` command — adds an item to favorites.
public struct FavoritesAddHandler {

    /// Valid Apple Music API resource types for favorites.
    static let validTypes = ["songs", "albums", "playlists", "artists", "music-videos", "stations"]

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

        let result = try await services.favorites.addFavorite(type: type, id: id)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

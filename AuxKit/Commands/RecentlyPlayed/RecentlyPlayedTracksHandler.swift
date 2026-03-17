//
//  RecentlyPlayedTracksHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for fetching recently played tracks.
public struct RecentlyPlayedTracksHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        limit: Int = 25,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let results = try await services.recentlyPlayed.getRecentlyPlayedTracks(limit: limit)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: results))
    }
}

//
//  RecentlyPlayedContainersHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for fetching recently played containers (albums, playlists, stations).
public struct RecentlyPlayedContainersHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        limit: Int = 10,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.recentlyPlayed.getRecentlyPlayedContainers(limit: limit)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

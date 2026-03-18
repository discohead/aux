//
//  RecentlyPlayedStationsHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Handler for the `history recently-played-stations` command — fetches recently played stations.
public struct RecentlyPlayedStationsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        limit: Int = 25,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let results = try await services.history.getRecentlyPlayedStations(limit: limit)
        let meta = PaginationMeta(limit: limit, offset: 0, total: nil, hasNext: results.count == limit)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: results, meta: meta))
    }
}

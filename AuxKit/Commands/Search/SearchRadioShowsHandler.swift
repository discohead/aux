//
//  SearchRadioShowsHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for searching radio shows in the Apple Music catalog.
public struct SearchRadioShowsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        query: String,
        limit: Int = 25,
        offset: Int = 0,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let results = try await services.catalog.searchRadioShows(query: query, limit: limit, offset: offset)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: results, meta: PaginationMeta(limit: limit, offset: offset, total: nil, hasNext: results.count == limit)))
    }
}

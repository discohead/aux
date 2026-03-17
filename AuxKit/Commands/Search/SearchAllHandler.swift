//
//  SearchAllHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for searching all types in the Apple Music catalog.
public struct SearchAllHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        query: String,
        types: [String] = ["songs", "albums", "artists", "playlists"],
        limit: Int = 25,
        offset: Int = 0,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let results = try await services.catalog.searchAll(query: query, types: types, limit: limit, offset: offset)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: results, meta: PaginationMeta(limit: limit, offset: offset, total: nil, hasNext: nil)))
    }
}

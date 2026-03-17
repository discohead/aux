//
//  SearchSuggestionsHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for getting search suggestions from the Apple Music catalog.
public struct SearchSuggestionsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        query: String,
        limit: Int = 10,
        types: [String]? = nil,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        guard limit >= 1, limit <= 25 else {
            throw AuxError.usageError(message: "Limit must be between 1 and 25 (got \(limit))")
        }
        let results = try await services.catalog.getSuggestions(query: query, limit: limit, types: types)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: results))
    }
}

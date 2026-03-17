//
//  CatalogChartsHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for getting charts from the Apple Music catalog.
public struct CatalogChartsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        kinds: [String],
        types: [String],
        genreId: String? = nil,
        limit: Int = 25,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.catalog.getCharts(kinds: kinds, types: types, genreId: genreId, limit: limit)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

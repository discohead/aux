//
//  CatalogAllGenresHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for getting all genres from the Apple Music catalog.
public struct CatalogAllGenresHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.catalog.getAllGenres()
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

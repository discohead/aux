//
//  CatalogStationsForGenreHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Handler for getting stations for a specific genre from the Apple Music catalog.
public struct CatalogStationsForGenreHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        storefront: String,
        genreId: String,
        limit: Int = 25,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let path = "/v1/catalog/\(storefront)/station-genres/\(genreId)/stations"
        let queryParams = ["limit": String(limit)]
        let data = try await services.restAPI.get(path: path, queryParams: queryParams)
        let stations = try parseStations(from: data)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: stations))
    }
}

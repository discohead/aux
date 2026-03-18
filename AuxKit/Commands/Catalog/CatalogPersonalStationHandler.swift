//
//  CatalogPersonalStationHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Handler for getting the user's personal station from the Apple Music catalog.
public struct CatalogPersonalStationHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        storefront: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let path = "/v1/catalog/\(storefront)/stations"
        let queryParams = ["filter[identity]": "personal"]
        let data = try await services.restAPI.get(path: path, queryParams: queryParams)
        let stations = try parseStations(from: data)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: stations))
    }
}

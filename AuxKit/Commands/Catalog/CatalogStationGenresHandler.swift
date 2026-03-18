//
//  CatalogStationGenresHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Handler for getting station genres from the Apple Music catalog.
public struct CatalogStationGenresHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        storefront: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let path = "/v1/catalog/\(storefront)/station-genres"
        let data = try await services.restAPI.get(path: path, queryParams: nil)
        let genres = try parseStationGenres(from: data)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: StationGenresResult(genres: genres)))
    }

    private static func parseStationGenres(from data: Data) throws -> [StationGenre] {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let dataArray = json["data"] as? [[String: Any]]
        else {
            return []
        }
        return dataArray.compactMap { item -> StationGenre? in
            guard let id = item["id"] as? String,
                  let attributes = item["attributes"] as? [String: Any],
                  let name = attributes["name"] as? String
            else {
                return nil
            }
            return StationGenre(id: id, name: name)
        }
    }
}

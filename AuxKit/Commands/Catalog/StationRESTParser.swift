//
//  StationRESTParser.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Parses an array of StationDTO from Apple Music REST API JSON response data.
func parseStations(from data: Data) throws -> [StationDTO] {
    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
          let dataArray = json["data"] as? [[String: Any]]
    else {
        return []
    }
    return dataArray.compactMap { item -> StationDTO? in
        guard let id = item["id"] as? String,
              let attributes = item["attributes"] as? [String: Any],
              let name = attributes["name"] as? String
        else {
            return nil
        }
        let artwork = attributes["artwork"] as? [String: Any]
        let artworkUrl = artwork?["url"] as? String
        let isLive = attributes["isLive"] as? Bool
        let stationProviderName = attributes["stationProviderName"] as? String
        let contentRating = attributes["contentRating"] as? String
        let url = attributes["url"] as? String

        return StationDTO(
            id: id,
            name: name,
            artworkUrl: artworkUrl,
            url: url,
            isLive: isLive,
            stationProviderName: stationProviderName,
            contentRating: contentRating
        )
    }
}

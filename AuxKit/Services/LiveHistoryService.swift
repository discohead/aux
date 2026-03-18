//
//  LiveHistoryService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation
import MusicKit

/// Live implementation of HistoryService using MusicDataRequest.
@available(macOS 14.0, *)
public struct LiveHistoryService: HistoryService {

    private static let baseURL = "https://api.music.apple.com"

    public init() {}

    public func getHeavyRotation(limit: Int) async throws -> HeavyRotationResult {
        let url = URL(string: "\(Self.baseURL)/v1/me/history/heavy-rotation?limit=\(limit)")!
        let request = MusicDataRequest(urlRequest: URLRequest(url: url))
        let response = try await request.response()
        let decoded = try JSONDecoder().decode(HeavyRotationAPIResponse.self, from: response.data)
        let items = decoded.data.map { item in
            HeavyRotationItem(
                type: item.type,
                id: item.id,
                name: item.attributes?.name ?? "",
                artworkUrl: item.attributes?.artwork?.url(width: 300, height: 300)
            )
        }
        return HeavyRotationResult(items: items)
    }

    public func getRecentlyPlayedStations(limit: Int) async throws -> [StationDTO] {
        var components = URLComponents(string: "\(Self.baseURL)/v1/me/recent/radio-stations")!
        components.queryItems = [URLQueryItem(name: "limit", value: String(limit))]
        let request = MusicDataRequest(urlRequest: URLRequest(url: components.url!))
        let response = try await request.response()
        let decoded = try JSONDecoder().decode(StationsAPIResponse.self, from: response.data)
        return decoded.data.map { station in
            StationDTO(
                id: station.id,
                name: station.attributes?.name ?? "",
                artworkUrl: station.attributes?.artwork?.url(width: 300, height: 300),
                isLive: station.attributes?.isLive
            )
        }
    }

    public func getRecentlyAddedResources(limit: Int) async throws -> RecentlyAddedResult {
        var components = URLComponents(string: "\(Self.baseURL)/v1/me/library/recently-added")!
        components.queryItems = [URLQueryItem(name: "limit", value: String(limit))]
        let request = MusicDataRequest(urlRequest: URLRequest(url: components.url!))
        let response = try await request.response()
        let decoded = try JSONDecoder().decode(RecentlyAddedAPIResponse.self, from: response.data)
        let items = decoded.data.map { item in
            RecentlyAddedItem(
                type: item.type,
                id: item.id,
                name: item.attributes?.name ?? "",
                artworkUrl: item.attributes?.artwork?.url(width: 300, height: 300)
            )
        }
        return RecentlyAddedResult(items: items)
    }
}

// MARK: - API Response Models

private struct HeavyRotationAPIResponse: Codable {
    let data: [HeavyRotationAPIItem]
}

private struct HeavyRotationAPIItem: Codable {
    let id: String
    let type: String
    let attributes: HeavyRotationAttributes?
}

private struct HeavyRotationAttributes: Codable {
    let name: String?
    let artwork: ArtworkInfo?
}

private struct ArtworkInfo: Codable {
    let width: Int?
    let height: Int?
    let url: String?

    func url(width: Int, height: Int) -> String? {
        guard let template = url else { return nil }
        return template
            .replacingOccurrences(of: "{w}", with: String(width))
            .replacingOccurrences(of: "{h}", with: String(height))
    }
}

private struct StationsAPIResponse: Codable {
    let data: [StationAPIItem]
}

private struct StationAPIItem: Codable {
    let id: String
    let attributes: StationAttributes?
}

private struct StationAttributes: Codable {
    let name: String?
    let artwork: ArtworkInfo?
    let isLive: Bool?
}

private struct RecentlyAddedAPIResponse: Codable {
    let data: [RecentlyAddedAPIItem]
}

private struct RecentlyAddedAPIItem: Codable {
    let id: String
    let type: String
    let attributes: RecentlyAddedAttributes?
}

private struct RecentlyAddedAttributes: Codable {
    let name: String?
    let artwork: ArtworkInfo?
}

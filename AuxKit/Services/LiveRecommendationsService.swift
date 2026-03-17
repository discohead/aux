//
//  LiveRecommendationsService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import MusicKit

/// Live implementation of RecommendationsService using MusicKit's personal recommendations.
public final class LiveRecommendationsService: RecommendationsService, Sendable {
    public init() {}

    public func getRecommendations(limit: Int) async throws -> RecommendationsResult {
        let request = MusicPersonalRecommendationsRequest()
        let response = try await request.response()
        let groups = response.recommendations.prefix(limit).map { rec in
            RecommendationGroup(
                title: rec.title,
                types: rec.types.map { String(describing: $0) },
                albums: rec.albums.isEmpty ? nil : rec.albums.map { album in
                    AlbumDTO(
                        id: album.id.rawValue,
                        title: album.title,
                        artistName: album.artistName,
                        genreNames: album.genreNames,
                        artworkUrl: album.artwork?.url(width: 300, height: 300)?.absoluteString
                    )
                },
                playlists: rec.playlists.isEmpty ? nil : rec.playlists.map { playlist in
                    PlaylistDTO(
                        id: playlist.id.rawValue,
                        name: playlist.name,
                        curatorName: playlist.curatorName,
                        artworkUrl: playlist.artwork?.url(width: 300, height: 300)?.absoluteString
                    )
                },
                stations: rec.stations.isEmpty ? nil : rec.stations.map { station in
                    StationDTO(
                        id: station.id.rawValue,
                        name: station.name,
                        artworkUrl: station.artwork?.url(width: 300, height: 300)?.absoluteString
                    )
                }
            )
        }
        return RecommendationsResult(recommendations: Array(groups))
    }
}

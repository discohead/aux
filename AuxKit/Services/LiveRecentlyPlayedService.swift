//
//  LiveRecentlyPlayedService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import MusicKit

/// Live implementation of RecentlyPlayedService using MusicKit's recently played APIs.
public final class LiveRecentlyPlayedService: RecentlyPlayedService, Sendable {
    public init() {}

    public func getRecentlyPlayedTracks(limit: Int) async throws -> [TrackDTO] {
        let request = MusicRecentlyPlayedRequest<Song>()
        let response = try await request.response()
        return Array(response.items.prefix(limit)).map { song in
            .song(SongDTO(
                id: song.id.rawValue,
                title: song.title,
                artistName: song.artistName,
                albumTitle: song.albumTitle,
                durationSeconds: song.duration,
                genreNames: song.genreNames,
                artworkUrl: song.artwork?.url(width: 300, height: 300)?.absoluteString
            ))
        }
    }

    public func getRecentlyPlayedContainers(limit: Int) async throws -> RecentlyPlayedContainersResult {
        // MusicRecentlyPlayedContainersRequest is not available in MusicKit.
        // Use MusicDataRequest to fetch from REST API instead.
        guard let url = URL(string: "https://api.music.apple.com/v1/me/recent/containers?limit=\(limit)") else {
            throw AuxError.serviceError(message: "Failed to build recently played containers URL")
        }
        let urlRequest = URLRequest(url: url)
        let dataRequest = MusicDataRequest(urlRequest: urlRequest)
        let response = try await dataRequest.response()

        // Parse the JSON response
        struct ContainerResponse: Decodable {
            struct ContainerData: Decodable {
                let id: String
                let type: String
                struct Attributes: Decodable {
                    let name: String?
                }
                let attributes: Attributes?
            }
            let data: [ContainerData]
        }

        let decoded = try JSONDecoder().decode(ContainerResponse.self, from: response.data)
        let items = decoded.data.map { container in
            RecentlyPlayedContainer(
                type: container.type,
                id: container.id,
                name: container.attributes?.name
            )
        }
        return RecentlyPlayedContainersResult(items: items)
    }
}

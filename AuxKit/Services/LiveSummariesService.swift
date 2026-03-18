//
//  LiveSummariesService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation
import MusicKit

/// Live implementation of SummariesService using MusicDataRequest.
/// References MusadoraKit's MusicSummaryRequest/MusicSummaryResponse for correct API format.
@available(macOS 14.0, *)
public struct LiveSummariesService: SummariesService {

    public init() {}

    public func getMusicSummaries(year: String, views: [String]) async throws -> MusicSummariesResult {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.music.apple.com"
        components.path = "/v1/me/music-summaries"

        var queryItems = [URLQueryItem(name: "filter[year]", value: year)]
        if !views.isEmpty {
            queryItems.append(URLQueryItem(name: "views", value: views.joined(separator: ",")))
        }
        // Include relationships so we get full artist/album/song objects
        queryItems.append(URLQueryItem(name: "include", value: "artist,album,song"))
        components.queryItems = queryItems

        let urlRequest = URLRequest(url: components.url!)
        let request = MusicDataRequest(urlRequest: urlRequest)
        let response = try await request.response()

        let decoded = try JSONDecoder().decode(SummariesResponsePayload.self, from: response.data)

        guard let summary = decoded.data.first else {
            return MusicSummariesResult(year: year)
        }

        let topArtists: [MusicSummaryEntry]? = summary.views?.topArtists?.data.compactMap { periodSummary in
            guard let artist = periodSummary.relationships?.artist?.data.first else { return nil }
            return MusicSummaryEntry(
                id: artist.id,
                name: artist.attributes?.name ?? "",
                artworkUrl: artist.attributes?.artwork?.url(width: 300, height: 300)
            )
        }

        let topAlbums: [MusicSummaryEntry]? = summary.views?.topAlbums?.data.compactMap { periodSummary in
            guard let album = periodSummary.relationships?.album?.data.first else { return nil }
            return MusicSummaryEntry(
                id: album.id,
                name: album.attributes?.name ?? "",
                artworkUrl: album.attributes?.artwork?.url(width: 300, height: 300)
            )
        }

        let topSongs: [MusicSummaryEntry]? = summary.views?.topSongs?.data.compactMap { periodSummary in
            guard let song = periodSummary.relationships?.song?.data.first else { return nil }
            return MusicSummaryEntry(
                id: song.id,
                name: song.attributes?.name ?? "",
                playCount: song.attributes?.playCount,
                artworkUrl: song.attributes?.artwork?.url(width: 300, height: 300)
            )
        }

        return MusicSummariesResult(
            year: summary.attributes?.year.map(String.init) ?? year,
            period: summary.attributes?.period,
            topArtists: topArtists,
            topAlbums: topAlbums,
            topSongs: topSongs
        )
    }
}

// MARK: - API Response Models (matches Apple Music API schema)

private struct SummariesResponsePayload: Decodable {
    let data: [SummariesPayload]
}

private struct SummariesPayload: Decodable {
    let id: String
    let type: String
    let attributes: SummariesAttributes?
    let views: SummariesViews?
}

private struct SummariesAttributes: Decodable {
    let period: String?
    let year: Int?
}

private struct SummariesViews: Decodable {
    let topAlbums: TopAlbumsView?
    let topArtists: TopArtistsView?
    let topSongs: TopSongsView?

    enum CodingKeys: String, CodingKey {
        case topAlbums = "top-albums"
        case topArtists = "top-artists"
        case topSongs = "top-songs"
    }
}

// MARK: - View containers

private struct TopAlbumsView: Decodable { let data: [AlbumPeriodSummary] }
private struct TopArtistsView: Decodable { let data: [ArtistPeriodSummary] }
private struct TopSongsView: Decodable { let data: [SongPeriodSummary] }

// MARK: - Period summary wrappers

private struct AlbumPeriodSummary: Decodable { let relationships: AlbumPeriodRelationships? }
private struct ArtistPeriodSummary: Decodable { let relationships: ArtistPeriodRelationships? }
private struct SongPeriodSummary: Decodable { let relationships: SongPeriodRelationships? }

// MARK: - Relationships

private struct AlbumPeriodRelationships: Decodable { let album: AlbumRelData? }
private struct ArtistPeriodRelationships: Decodable { let artist: ArtistRelData? }
private struct SongPeriodRelationships: Decodable { let song: SongRelData? }

private struct AlbumRelData: Decodable { let data: [ResourceItem] }
private struct ArtistRelData: Decodable { let data: [ResourceItem] }
private struct SongRelData: Decodable { let data: [ResourceItem] }

// MARK: - Generic resource item (we only need id, name, artwork, playCount)

private struct ResourceItem: Decodable {
    let id: String
    let attributes: ResourceAttributes?
}

private struct ResourceAttributes: Decodable {
    let name: String?
    let playCount: Int?
    let artwork: ResourceArtwork?
}

private struct ResourceArtwork: Decodable {
    let url: String?
    let width: Int?
    let height: Int?

    func url(width: Int, height: Int) -> String? {
        guard let template = url else { return nil }
        return template
            .replacingOccurrences(of: "{w}", with: String(width))
            .replacingOccurrences(of: "{h}", with: String(height))
    }
}

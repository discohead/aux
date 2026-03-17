//
//  PlaylistDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

public struct PlaylistDTO: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let curatorName: String?
    public let description: String?
    public let shortDescription: String?
    public let kind: String?
    public let lastModifiedDate: String?
    public let artworkUrl: String?
    public let url: String?
    public let isChart: Bool?
    public let hasCollaboration: Bool?
    public let tracks: [TrackDTO]?

    enum CodingKeys: String, CodingKey {
        case id, name, description, kind, url, tracks
        case curatorName = "curator_name"
        case shortDescription = "short_description"
        case lastModifiedDate = "last_modified_date"
        case artworkUrl = "artwork_url"
        case isChart = "is_chart"
        case hasCollaboration = "has_collaboration"
    }

    public init(
        id: String,
        name: String,
        curatorName: String? = nil,
        description: String? = nil,
        shortDescription: String? = nil,
        kind: String? = nil,
        lastModifiedDate: String? = nil,
        artworkUrl: String? = nil,
        url: String? = nil,
        isChart: Bool? = nil,
        hasCollaboration: Bool? = nil,
        tracks: [TrackDTO]? = nil
    ) {
        self.id = id
        self.name = name
        self.curatorName = curatorName
        self.description = description
        self.shortDescription = shortDescription
        self.kind = kind
        self.lastModifiedDate = lastModifiedDate
        self.artworkUrl = artworkUrl
        self.url = url
        self.isChart = isChart
        self.hasCollaboration = hasCollaboration
        self.tracks = tracks
    }

    public static func fixture(
        id: String = "pl.1",
        name: String = "Test Playlist",
        curatorName: String? = nil,
        description: String? = nil,
        shortDescription: String? = nil,
        kind: String? = nil,
        lastModifiedDate: String? = nil,
        artworkUrl: String? = nil,
        url: String? = nil,
        isChart: Bool? = nil,
        hasCollaboration: Bool? = nil,
        tracks: [TrackDTO]? = nil
    ) -> Self {
        .init(
            id: id,
            name: name,
            curatorName: curatorName,
            description: description,
            shortDescription: shortDescription,
            kind: kind,
            lastModifiedDate: lastModifiedDate,
            artworkUrl: artworkUrl,
            url: url,
            isChart: isChart,
            hasCollaboration: hasCollaboration,
            tracks: tracks
        )
    }
}

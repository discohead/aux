//
//  StationDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

public struct StationDTO: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let artworkUrl: String?
    public let url: String?
    public let isLive: Bool?
    public let editorialNotes: EditorialNotes?
    public let stationProviderName: String?
    public let contentRating: String?
    public let duration: Int?
    public let episodeNumber: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case artworkUrl = "artwork_url"
        case url
        case isLive = "is_live"
        case editorialNotes = "editorial_notes"
        case stationProviderName = "station_provider_name"
        case contentRating = "content_rating"
        case duration
        case episodeNumber = "episode_number"
    }

    public init(
        id: String,
        name: String,
        artworkUrl: String? = nil,
        url: String? = nil,
        isLive: Bool? = nil,
        editorialNotes: EditorialNotes? = nil,
        stationProviderName: String? = nil,
        contentRating: String? = nil,
        duration: Int? = nil,
        episodeNumber: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.artworkUrl = artworkUrl
        self.url = url
        self.isLive = isLive
        self.editorialNotes = editorialNotes
        self.stationProviderName = stationProviderName
        self.contentRating = contentRating
        self.duration = duration
        self.episodeNumber = episodeNumber
    }

    public static func fixture(
        id: String = "st.1",
        name: String = "Apple Music 1",
        artworkUrl: String? = nil,
        url: String? = nil,
        isLive: Bool? = nil,
        editorialNotes: EditorialNotes? = nil,
        stationProviderName: String? = nil,
        contentRating: String? = nil,
        duration: Int? = nil,
        episodeNumber: Int? = nil
    ) -> Self {
        .init(
            id: id,
            name: name,
            artworkUrl: artworkUrl,
            url: url,
            isLive: isLive,
            editorialNotes: editorialNotes,
            stationProviderName: stationProviderName,
            contentRating: contentRating,
            duration: duration,
            episodeNumber: episodeNumber
        )
    }
}

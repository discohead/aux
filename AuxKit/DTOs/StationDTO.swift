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

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case artworkUrl = "artwork_url"
        case url
        case isLive = "is_live"
        case editorialNotes = "editorial_notes"
    }

    public init(
        id: String,
        name: String,
        artworkUrl: String? = nil,
        url: String? = nil,
        isLive: Bool? = nil,
        editorialNotes: EditorialNotes? = nil
    ) {
        self.id = id
        self.name = name
        self.artworkUrl = artworkUrl
        self.url = url
        self.isLive = isLive
        self.editorialNotes = editorialNotes
    }

    public static func fixture(
        id: String = "st.1",
        name: String = "Apple Music 1",
        artworkUrl: String? = nil,
        url: String? = nil,
        isLive: Bool? = nil,
        editorialNotes: EditorialNotes? = nil
    ) -> Self {
        .init(
            id: id,
            name: name,
            artworkUrl: artworkUrl,
            url: url,
            isLive: isLive,
            editorialNotes: editorialNotes
        )
    }
}

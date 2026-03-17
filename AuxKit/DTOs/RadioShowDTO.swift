//
//  RadioShowDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

public struct RadioShowDTO: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let artworkUrl: String?
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case artworkUrl = "artwork_url"
        case url
    }

    public init(
        id: String,
        name: String,
        artworkUrl: String? = nil,
        url: String? = nil
    ) {
        self.id = id
        self.name = name
        self.artworkUrl = artworkUrl
        self.url = url
    }

    public static func fixture(
        id: String = "rs.1",
        name: String = "The Zane Lowe Show",
        artworkUrl: String? = nil,
        url: String? = nil
    ) -> Self {
        .init(
            id: id,
            name: name,
            artworkUrl: artworkUrl,
            url: url
        )
    }
}

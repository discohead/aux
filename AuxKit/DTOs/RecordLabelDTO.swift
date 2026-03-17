//
//  RecordLabelDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

public struct RecordLabelDTO: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let artworkUrl: String?
    public let url: String?
    public let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case artworkUrl = "artwork_url"
        case url
        case description
    }

    public init(
        id: String,
        name: String,
        artworkUrl: String? = nil,
        url: String? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.artworkUrl = artworkUrl
        self.url = url
        self.description = description
    }

    public static func fixture(
        id: String = "rl.1",
        name: String = "Interscope Records",
        artworkUrl: String? = nil,
        url: String? = nil,
        description: String? = nil
    ) -> Self {
        .init(
            id: id,
            name: name,
            artworkUrl: artworkUrl,
            url: url,
            description: description
        )
    }
}

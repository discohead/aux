//
//  GenreDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

public struct GenreDTO: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let parent: ParentRef?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case parent
    }

    public init(id: String, name: String, parent: ParentRef? = nil) {
        self.id = id
        self.name = name
        self.parent = parent
    }

    public static func fixture(
        id: String = "1",
        name: String = "Rock",
        parent: ParentRef? = nil
    ) -> Self {
        .init(id: id, name: name, parent: parent)
    }

    public struct ParentRef: Codable, Equatable, Sendable {
        public let id: String
        public let name: String

        enum CodingKeys: String, CodingKey {
            case id
            case name
        }

        public init(id: String, name: String) {
            self.id = id
            self.name = name
        }

        public static func fixture(
            id: String = "34",
            name: String = "Music"
        ) -> Self {
            .init(id: id, name: name)
        }
    }
}

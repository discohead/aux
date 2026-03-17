//
//  TopResultDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// A simple search result type.
public struct TopResultDTO: Codable, Equatable, Sendable {
    public let type: String
    public let id: String
    public let title: String

    enum CodingKeys: String, CodingKey {
        case type, id, title
    }

    public init(type: String, id: String, title: String) {
        self.type = type
        self.id = id
        self.title = title
    }

    public static func fixture(
        type: String = "song",
        id: String = "1",
        title: String = "Test Result"
    ) -> TopResultDTO {
        TopResultDTO(type: type, id: id, title: title)
    }
}

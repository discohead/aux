//
//  ChartDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// A generic chart container for ranked items.
public struct ChartDTO<T: Codable & Equatable & Sendable>: Codable, Equatable, Sendable {
    public let title: String
    public let kind: String
    public let items: [T]
    public let hasNext: Bool

    enum CodingKeys: String, CodingKey {
        case title, kind, items
        case hasNext = "has_next"
    }

    public init(title: String, kind: String, items: [T], hasNext: Bool) {
        self.title = title
        self.kind = kind
        self.items = items
        self.hasNext = hasNext
    }

    public static func fixture(
        title: String = "Test Chart",
        kind: String = "songs",
        items: [T] = [],
        hasNext: Bool = false
    ) -> ChartDTO<T> {
        ChartDTO(title: title, kind: kind, items: items, hasNext: hasNext)
    }
}

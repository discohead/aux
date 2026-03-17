//
//  EditorialNotes.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

public struct EditorialNotes: Codable, Equatable, Sendable {
    public let standard: String?
    public let short: String?

    enum CodingKeys: String, CodingKey {
        case standard
        case short
    }

    public init(standard: String? = nil, short: String? = nil) {
        self.standard = standard
        self.short = short
    }

    public static func fixture(
        standard: String? = "Standard notes",
        short: String? = "Short notes"
    ) -> Self {
        .init(standard: standard, short: short)
    }
}

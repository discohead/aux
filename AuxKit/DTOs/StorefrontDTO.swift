//
//  StorefrontDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

public struct StorefrontDTO: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let defaultLanguage: String
    public let supportedLanguages: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case defaultLanguage = "default_language"
        case supportedLanguages = "supported_languages"
    }

    public init(
        id: String,
        name: String,
        defaultLanguage: String,
        supportedLanguages: [String]? = nil
    ) {
        self.id = id
        self.name = name
        self.defaultLanguage = defaultLanguage
        self.supportedLanguages = supportedLanguages
    }

    public static func fixture(
        id: String = "us",
        name: String = "United States",
        defaultLanguage: String = "en-US",
        supportedLanguages: [String]? = nil
    ) -> Self {
        .init(
            id: id,
            name: name,
            defaultLanguage: defaultLanguage,
            supportedLanguages: supportedLanguages
        )
    }
}

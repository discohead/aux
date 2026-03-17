//
//  SimpleDTOTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Testing
import Foundation
@testable import AuxKit

// MARK: - GenreDTO Tests

struct GenreDTOTests {

    @Test func roundTripsViaJSON() throws {
        let parent = GenreDTO.ParentRef(id: "34", name: "Music")
        let original = GenreDTO(id: "21", name: "Rock", parent: parent)

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(GenreDTO.self, from: data)

        #expect(decoded == original)
    }

    @Test func roundTripsViaJSONWithNilParent() throws {
        let original = GenreDTO(id: "21", name: "Rock", parent: nil)

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(GenreDTO.self, from: data)

        #expect(decoded == original)
    }

    @Test func usesSnakeCaseKeys() throws {
        let parent = GenreDTO.ParentRef(id: "34", name: "Music")
        let genre = GenreDTO(id: "21", name: "Rock", parent: parent)

        let data = try JSONEncoder().encode(genre)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"id\""))
        #expect(json.contains("\"name\""))
        #expect(json.contains("\"parent\""))
    }
}

// MARK: - StorefrontDTO Tests

struct StorefrontDTOTests {

    @Test func roundTripsViaJSON() throws {
        let original = StorefrontDTO(
            id: "us",
            name: "United States",
            defaultLanguage: "en-US",
            supportedLanguages: ["en-US", "es-MX"]
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(StorefrontDTO.self, from: data)

        #expect(decoded == original)
    }

    @Test func roundTripsViaJSONWithNilSupportedLanguages() throws {
        let original = StorefrontDTO(
            id: "us",
            name: "United States",
            defaultLanguage: "en-US",
            supportedLanguages: nil
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(StorefrontDTO.self, from: data)

        #expect(decoded == original)
    }

    @Test func usesSnakeCaseKeys() throws {
        let storefront = StorefrontDTO(
            id: "us",
            name: "United States",
            defaultLanguage: "en-US",
            supportedLanguages: ["en-US", "es-MX"]
        )

        let data = try JSONEncoder().encode(storefront)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"default_language\""))
        #expect(json.contains("\"supported_languages\""))
        #expect(!json.contains("\"defaultLanguage\""))
        #expect(!json.contains("\"supportedLanguages\""))
    }
}

// MARK: - StationDTO Tests

struct StationDTOTests {

    @Test func roundTripsViaJSON() throws {
        let notes = EditorialNotes(standard: "A great station for rock fans.", short: "Rock hits")
        let original = StationDTO(
            id: "ra.123456",
            name: "Rock Classics",
            artworkUrl: "https://example.com/artwork.jpg",
            url: "https://music.apple.com/station/rock-classics",
            isLive: true,
            editorialNotes: notes
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(StationDTO.self, from: data)

        #expect(decoded == original)
    }

    @Test func roundTripsViaJSONWithAllNils() throws {
        let original = StationDTO(
            id: "ra.789",
            name: "Minimal Station",
            artworkUrl: nil,
            url: nil,
            isLive: nil,
            editorialNotes: nil
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(StationDTO.self, from: data)

        #expect(decoded == original)
    }

    @Test func usesSnakeCaseKeys() throws {
        let notes = EditorialNotes(standard: "Notes here", short: "Short")
        let station = StationDTO(
            id: "ra.123",
            name: "Test Station",
            artworkUrl: "https://example.com/art.jpg",
            url: "https://example.com",
            isLive: true,
            editorialNotes: notes
        )

        let data = try JSONEncoder().encode(station)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"artwork_url\""))
        #expect(json.contains("\"is_live\""))
        #expect(json.contains("\"editorial_notes\""))
        #expect(!json.contains("\"artworkUrl\""))
        #expect(!json.contains("\"isLive\""))
        #expect(!json.contains("\"editorialNotes\""))
    }
}

// MARK: - RadioShowDTO Tests

struct RadioShowDTOTests {

    @Test func roundTripsViaJSON() throws {
        let original = RadioShowDTO(
            id: "rs.100",
            name: "The Zane Lowe Show",
            artworkUrl: "https://example.com/zane.jpg",
            url: "https://music.apple.com/show/zane-lowe"
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(RadioShowDTO.self, from: data)

        #expect(decoded == original)
    }

    @Test func roundTripsViaJSONWithNils() throws {
        let original = RadioShowDTO(
            id: "rs.200",
            name: "Minimal Show",
            artworkUrl: nil,
            url: nil
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(RadioShowDTO.self, from: data)

        #expect(decoded == original)
    }

    @Test func usesSnakeCaseKeys() throws {
        let show = RadioShowDTO(
            id: "rs.100",
            name: "The Zane Lowe Show",
            artworkUrl: "https://example.com/zane.jpg",
            url: "https://music.apple.com/show/zane-lowe"
        )

        let data = try JSONEncoder().encode(show)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"artwork_url\""))
        #expect(!json.contains("\"artworkUrl\""))
    }
}

// MARK: - CuratorDTO Tests

struct CuratorDTOTests {

    @Test func roundTripsViaJSON() throws {
        let notes = EditorialNotes(standard: "Apple Music's pop experts.", short: "Pop picks")
        let original = CuratorDTO(
            id: "cu.456",
            name: "Apple Music Pop",
            artworkUrl: "https://example.com/pop.jpg",
            url: "https://music.apple.com/curator/apple-music-pop",
            editorialNotes: notes
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(CuratorDTO.self, from: data)

        #expect(decoded == original)
    }

    @Test func roundTripsViaJSONWithNils() throws {
        let original = CuratorDTO(
            id: "cu.789",
            name: "Minimal Curator",
            artworkUrl: nil,
            url: nil,
            editorialNotes: nil
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(CuratorDTO.self, from: data)

        #expect(decoded == original)
    }

    @Test func usesSnakeCaseKeys() throws {
        let notes = EditorialNotes(standard: "Great curator", short: "Curator")
        let curator = CuratorDTO(
            id: "cu.456",
            name: "Test Curator",
            artworkUrl: "https://example.com/art.jpg",
            url: "https://example.com",
            editorialNotes: notes
        )

        let data = try JSONEncoder().encode(curator)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"artwork_url\""))
        #expect(json.contains("\"editorial_notes\""))
        #expect(!json.contains("\"artworkUrl\""))
        #expect(!json.contains("\"editorialNotes\""))
    }
}

// MARK: - RecordLabelDTO Tests

struct RecordLabelDTOTests {

    @Test func roundTripsViaJSON() throws {
        let original = RecordLabelDTO(
            id: "rl.321",
            name: "Republic Records",
            artworkUrl: "https://example.com/republic.jpg",
            url: "https://music.apple.com/label/republic",
            description: "One of the biggest record labels in the world."
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(RecordLabelDTO.self, from: data)

        #expect(decoded == original)
    }

    @Test func roundTripsViaJSONWithNils() throws {
        let original = RecordLabelDTO(
            id: "rl.999",
            name: "Minimal Label",
            artworkUrl: nil,
            url: nil,
            description: nil
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(RecordLabelDTO.self, from: data)

        #expect(decoded == original)
    }

    @Test func usesSnakeCaseKeys() throws {
        let label = RecordLabelDTO(
            id: "rl.321",
            name: "Republic Records",
            artworkUrl: "https://example.com/republic.jpg",
            url: "https://example.com",
            description: "A great label."
        )

        let data = try JSONEncoder().encode(label)
        let json = String(data: data, encoding: .utf8)!

        #expect(json.contains("\"artwork_url\""))
        #expect(json.contains("\"description\""))
        #expect(!json.contains("\"artworkUrl\""))
    }
}

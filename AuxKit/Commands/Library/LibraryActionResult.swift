//
//  LibraryActionResult.swift
//  AuxKit
//

import Foundation

/// Generic success result for void-returning library commands.
public struct LibraryActionResult: Codable, Equatable, Sendable {
    public let success: Bool
    public let message: String?

    public init(success: Bool = true, message: String? = nil) {
        self.success = success
        self.message = message
    }
}

/// Wrapper for lyrics text to enable Codable envelope output.
public struct LyricsResult: Codable, Equatable, Sendable {
    public let trackId: Int
    public let lyrics: String?

    enum CodingKeys: String, CodingKey {
        case trackId = "track_id"
        case lyrics
    }

    public init(trackId: Int, lyrics: String?) {
        self.trackId = trackId
        self.lyrics = lyrics
    }
}

/// Wrapper for artwork count to enable Codable envelope output.
public struct ArtworkCountResult: Codable, Equatable, Sendable {
    public let trackId: Int
    public let count: Int

    enum CodingKeys: String, CodingKey {
        case trackId = "track_id"
        case count
    }

    public init(trackId: Int, count: Int) {
        self.trackId = trackId
        self.count = count
    }
}

/// Wrapper for reveal path to enable Codable envelope output.
public struct RevealResult: Codable, Equatable, Sendable {
    public let trackId: Int
    public let path: String

    enum CodingKeys: String, CodingKey {
        case trackId = "track_id"
        case path
    }

    public init(trackId: Int, path: String) {
        self.trackId = trackId
        self.path = path
    }
}

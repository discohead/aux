//
//  TrackDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// A union type representing either a song or a music video track.
public enum TrackDTO: Codable, Equatable, Sendable {
    case song(SongDTO)
    case musicVideo(MusicVideoDTO)

    enum CodingKeys: String, CodingKey {
        case type
        case song
        case musicVideo = "music_video"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "song":
            let value = try container.decode(SongDTO.self, forKey: .song)
            self = .song(value)
        case "music_video":
            let value = try container.decode(MusicVideoDTO.self, forKey: .musicVideo)
            self = .musicVideo(value)
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type, in: container,
                debugDescription: "Unknown track type: \(type)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .song(let dto):
            try container.encode("song", forKey: .type)
            try container.encode(dto, forKey: .song)
        case .musicVideo(let dto):
            try container.encode("music_video", forKey: .type)
            try container.encode(dto, forKey: .musicVideo)
        }
    }

    // MARK: - Convenience

    /// Struct-style convenience initializer. The `type` string determines which
    /// associated value is used; the other parameter is ignored.
    public init(type: String, song: SongDTO? = nil, musicVideo: MusicVideoDTO? = nil) {
        switch type {
        case "music_video":
            self = .musicVideo(musicVideo!)
        default:
            self = .song(song!)
        }
    }

    /// The discriminator string (`"song"` or `"music_video"`).
    public var type: String {
        switch self {
        case .song: return "song"
        case .musicVideo: return "music_video"
        }
    }

    /// The song payload, if this is a `.song` track.
    public var song: SongDTO? {
        if case .song(let dto) = self { return dto }
        return nil
    }

    /// The music video payload, if this is a `.musicVideo` track.
    public var musicVideo: MusicVideoDTO? {
        if case .musicVideo(let dto) = self { return dto }
        return nil
    }

    public static func fixture(
        type: String = "song",
        song: SongDTO? = SongDTO.fixture(),
        musicVideo: MusicVideoDTO? = nil
    ) -> Self {
        switch type {
        case "music_video":
            return .musicVideo(musicVideo ?? MusicVideoDTO.fixture())
        default:
            return .song(song ?? SongDTO.fixture())
        }
    }
}

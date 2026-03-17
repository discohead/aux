//
//  AlbumDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

public struct AlbumDTO: Codable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let artistName: String
    public let trackCount: Int?
    public let genreNames: [String]
    public let releaseDate: String?
    public let upc: String?
    public let isCompilation: Bool?
    public let isComplete: Bool?
    public let isSingle: Bool?
    public let contentRating: String?
    public let artworkUrl: String?
    public let url: String?
    public let editorialNotes: EditorialNotes?
    public let recordLabelName: String?
    public let audioVariants: [String]?
    public let isAppleDigitalMaster: Bool?
    public let tracks: [SongDTO]?

    enum CodingKeys: String, CodingKey {
        case id, title, url, upc, tracks
        case artistName = "artist_name"
        case trackCount = "track_count"
        case genreNames = "genre_names"
        case releaseDate = "release_date"
        case isCompilation = "is_compilation"
        case isComplete = "is_complete"
        case isSingle = "is_single"
        case contentRating = "content_rating"
        case artworkUrl = "artwork_url"
        case editorialNotes = "editorial_notes"
        case recordLabelName = "record_label_name"
        case audioVariants = "audio_variants"
        case isAppleDigitalMaster = "is_apple_digital_master"
    }

    public init(
        id: String,
        title: String,
        artistName: String,
        trackCount: Int? = nil,
        genreNames: [String] = [],
        releaseDate: String? = nil,
        upc: String? = nil,
        isCompilation: Bool? = nil,
        isComplete: Bool? = nil,
        isSingle: Bool? = nil,
        contentRating: String? = nil,
        artworkUrl: String? = nil,
        url: String? = nil,
        editorialNotes: EditorialNotes? = nil,
        recordLabelName: String? = nil,
        audioVariants: [String]? = nil,
        isAppleDigitalMaster: Bool? = nil,
        tracks: [SongDTO]? = nil
    ) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.trackCount = trackCount
        self.genreNames = genreNames
        self.releaseDate = releaseDate
        self.upc = upc
        self.isCompilation = isCompilation
        self.isComplete = isComplete
        self.isSingle = isSingle
        self.contentRating = contentRating
        self.artworkUrl = artworkUrl
        self.url = url
        self.editorialNotes = editorialNotes
        self.recordLabelName = recordLabelName
        self.audioVariants = audioVariants
        self.isAppleDigitalMaster = isAppleDigitalMaster
        self.tracks = tracks
    }

    public static func fixture(
        id: String = "1",
        title: String = "Test Album",
        artistName: String = "Test Artist",
        trackCount: Int? = nil,
        genreNames: [String] = ["Pop"],
        releaseDate: String? = nil,
        upc: String? = nil,
        isCompilation: Bool? = nil,
        isComplete: Bool? = nil,
        isSingle: Bool? = nil,
        contentRating: String? = nil,
        artworkUrl: String? = nil,
        url: String? = nil,
        editorialNotes: EditorialNotes? = nil,
        recordLabelName: String? = nil,
        audioVariants: [String]? = nil,
        isAppleDigitalMaster: Bool? = nil,
        tracks: [SongDTO]? = nil
    ) -> Self {
        .init(
            id: id,
            title: title,
            artistName: artistName,
            trackCount: trackCount,
            genreNames: genreNames,
            releaseDate: releaseDate,
            upc: upc,
            isCompilation: isCompilation,
            isComplete: isComplete,
            isSingle: isSingle,
            contentRating: contentRating,
            artworkUrl: artworkUrl,
            url: url,
            editorialNotes: editorialNotes,
            recordLabelName: recordLabelName,
            audioVariants: audioVariants,
            isAppleDigitalMaster: isAppleDigitalMaster,
            tracks: tracks
        )
    }
}

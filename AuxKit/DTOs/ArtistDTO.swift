//
//  ArtistDTO.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

public struct ArtistDTO: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let genreNames: [String]?
    public let artworkUrl: String?
    public let url: String?
    public let editorialNotes: EditorialNotes?
    public let topSongs: [SongDTO]?
    public let albums: [AlbumDTO]?

    enum CodingKeys: String, CodingKey {
        case id, name, url, albums
        case genreNames = "genre_names"
        case artworkUrl = "artwork_url"
        case editorialNotes = "editorial_notes"
        case topSongs = "top_songs"
    }

    public init(
        id: String,
        name: String,
        genreNames: [String]? = nil,
        artworkUrl: String? = nil,
        url: String? = nil,
        editorialNotes: EditorialNotes? = nil,
        topSongs: [SongDTO]? = nil,
        albums: [AlbumDTO]? = nil
    ) {
        self.id = id
        self.name = name
        self.genreNames = genreNames
        self.artworkUrl = artworkUrl
        self.url = url
        self.editorialNotes = editorialNotes
        self.topSongs = topSongs
        self.albums = albums
    }

    public static func fixture(
        id: String = "1",
        name: String = "Test Artist",
        genreNames: [String]? = nil,
        artworkUrl: String? = nil,
        url: String? = nil,
        editorialNotes: EditorialNotes? = nil,
        topSongs: [SongDTO]? = nil,
        albums: [AlbumDTO]? = nil
    ) -> Self {
        .init(
            id: id,
            name: name,
            genreNames: genreNames,
            artworkUrl: artworkUrl,
            url: url,
            editorialNotes: editorialNotes,
            topSongs: topSongs,
            albums: albums
        )
    }
}

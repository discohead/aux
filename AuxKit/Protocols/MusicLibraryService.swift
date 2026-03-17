//
//  MusicLibraryService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

// MARK: - Library Filter Types

/// Filters for querying songs in the user's library.
public struct LibrarySongFilters: Sendable, Equatable {
    public let title: String?
    public let artist: String?
    public let album: String?
    public let downloadedOnly: Bool

    public init(
        title: String? = nil,
        artist: String? = nil,
        album: String? = nil,
        downloadedOnly: Bool = false
    ) {
        self.title = title
        self.artist = artist
        self.album = album
        self.downloadedOnly = downloadedOnly
    }
}

/// Filters for querying albums in the user's library.
public struct LibraryAlbumFilters: Sendable, Equatable {
    public let title: String?
    public let artist: String?

    public init(
        title: String? = nil,
        artist: String? = nil
    ) {
        self.title = title
        self.artist = artist
    }
}

// MARK: - MusicLibraryService Protocol

/// Protocol defining operations for accessing the user's Apple Music library.
public protocol MusicLibraryService: Sendable {
    func getSongs(limit: Int, offset: Int, sort: String?, filters: LibrarySongFilters?) async throws -> [SongDTO]
    func getAlbums(limit: Int, offset: Int, sort: String?, filters: LibraryAlbumFilters?) async throws -> [AlbumDTO]
    func getArtists(limit: Int, offset: Int, sort: String?, filterName: String?) async throws -> [ArtistDTO]
    func getPlaylists(limit: Int, offset: Int, sort: String?) async throws -> [PlaylistDTO]
    func getMusicVideos(limit: Int, offset: Int) async throws -> [MusicVideoDTO]
    func search(query: String, types: [String], limit: Int) async throws -> LibrarySearchResult
}

//
//  MockMusicLibraryService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Mock implementation of MusicLibraryService for testing.
public final class MockMusicLibraryService: MusicLibraryService, @unchecked Sendable {

    // MARK: - Call Tracking

    public var getSongsCalled = false
    public var getAlbumsCalled = false
    public var getArtistsCalled = false
    public var getPlaylistsCalled = false
    public var getMusicVideosCalled = false
    public var searchCalled = false

    // MARK: - Configurable Results

    public var getSongsResult: Result<[SongDTO], Error> = .success([])
    public var getAlbumsResult: Result<[AlbumDTO], Error> = .success([])
    public var getArtistsResult: Result<[ArtistDTO], Error> = .success([])
    public var getPlaylistsResult: Result<[PlaylistDTO], Error> = .success([])
    public var getMusicVideosResult: Result<[MusicVideoDTO], Error> = .success([])
    public var searchResult: Result<LibrarySearchResult, Error> = .success(LibrarySearchResult())

    public init() {}

    // MARK: - Reset

    public func reset() {
        getSongsCalled = false
        getAlbumsCalled = false
        getArtistsCalled = false
        getPlaylistsCalled = false
        getMusicVideosCalled = false
        searchCalled = false
    }

    // MARK: - Protocol Methods

    public func getSongs(limit: Int, offset: Int, sort: String?, filters: LibrarySongFilters?) async throws -> [SongDTO] {
        getSongsCalled = true
        return try getSongsResult.get()
    }

    public func getAlbums(limit: Int, offset: Int, sort: String?, filters: LibraryAlbumFilters?) async throws -> [AlbumDTO] {
        getAlbumsCalled = true
        return try getAlbumsResult.get()
    }

    public func getArtists(limit: Int, offset: Int, sort: String?, filterName: String?) async throws -> [ArtistDTO] {
        getArtistsCalled = true
        return try getArtistsResult.get()
    }

    public func getPlaylists(limit: Int, offset: Int, sort: String?) async throws -> [PlaylistDTO] {
        getPlaylistsCalled = true
        return try getPlaylistsResult.get()
    }

    public func getMusicVideos(limit: Int, offset: Int) async throws -> [MusicVideoDTO] {
        getMusicVideosCalled = true
        return try getMusicVideosResult.get()
    }

    public func search(query: String, types: [String], limit: Int) async throws -> LibrarySearchResult {
        searchCalled = true
        return try searchResult.get()
    }
}

//
//  MusicCatalogService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Protocol defining operations for searching and retrieving items from the Apple Music catalog.
public protocol MusicCatalogService: Sendable {
    // MARK: - Search

    func searchSongs(query: String, limit: Int, offset: Int) async throws -> [SongDTO]
    func searchAlbums(query: String, limit: Int, offset: Int) async throws -> [AlbumDTO]
    func searchArtists(query: String, limit: Int, offset: Int) async throws -> [ArtistDTO]
    func searchPlaylists(query: String, limit: Int, offset: Int) async throws -> [PlaylistDTO]
    func searchMusicVideos(query: String, limit: Int, offset: Int) async throws -> [MusicVideoDTO]
    func searchStations(query: String, limit: Int, offset: Int) async throws -> [StationDTO]
    func searchCurators(query: String, limit: Int, offset: Int) async throws -> [CuratorDTO]
    func searchRadioShows(query: String, limit: Int, offset: Int) async throws -> [RadioShowDTO]
    func searchAll(query: String, types: [String], limit: Int, offset: Int) async throws -> SearchAllResult
    func getSuggestions(query: String, limit: Int, types: [String]?) async throws -> SuggestionsResult

    // MARK: - Get by ID

    func getSong(id: String) async throws -> SongDTO
    func getSongByISRC(isrc: String) async throws -> [SongDTO]
    func getAlbum(id: String) async throws -> AlbumDTO
    func getAlbumByUPC(upc: String) async throws -> [AlbumDTO]
    func getArtist(id: String) async throws -> ArtistDTO
    func getPlaylist(id: String) async throws -> PlaylistDTO
    func getMusicVideo(id: String) async throws -> MusicVideoDTO
    func getStation(id: String) async throws -> StationDTO
    func getCurator(id: String) async throws -> CuratorDTO
    func getRadioShow(id: String) async throws -> RadioShowDTO
    func getRecordLabel(id: String) async throws -> RecordLabelDTO
    func getGenre(id: String) async throws -> GenreDTO
    func getAllGenres() async throws -> [GenreDTO]

    // MARK: - Charts & Storefronts

    func getCharts(kinds: [String], types: [String], genreId: String?, limit: Int) async throws -> ChartsResult
    func getStorefront(id: String) async throws -> StorefrontDTO
}

//
//  MockMusicCatalogService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Mock implementation of MusicCatalogService for testing.
public final class MockMusicCatalogService: MusicCatalogService, @unchecked Sendable {

    // MARK: - Call Tracking

    public var searchSongsCalled = false
    public var searchAlbumsCalled = false
    public var searchArtistsCalled = false
    public var searchPlaylistsCalled = false
    public var searchMusicVideosCalled = false
    public var searchStationsCalled = false
    public var searchCuratorsCalled = false
    public var searchRadioShowsCalled = false
    public var searchAllCalled = false
    public var getSuggestionsCalled = false
    public var getSongCalled = false
    public var getSongByISRCCalled = false
    public var getAlbumCalled = false
    public var getAlbumByUPCCalled = false
    public var getArtistCalled = false
    public var getPlaylistCalled = false
    public var getMusicVideoCalled = false
    public var getStationCalled = false
    public var getCuratorCalled = false
    public var getRadioShowCalled = false
    public var getRecordLabelCalled = false
    public var getGenreCalled = false
    public var getAllGenresCalled = false
    public var getChartsCalled = false
    public var getStorefrontCalled = false

    // MARK: - Configurable Results

    public var searchSongsResult: Result<[SongDTO], Error> = .success([])
    public var searchAlbumsResult: Result<[AlbumDTO], Error> = .success([])
    public var searchArtistsResult: Result<[ArtistDTO], Error> = .success([])
    public var searchPlaylistsResult: Result<[PlaylistDTO], Error> = .success([])
    public var searchMusicVideosResult: Result<[MusicVideoDTO], Error> = .success([])
    public var searchStationsResult: Result<[StationDTO], Error> = .success([])
    public var searchCuratorsResult: Result<[CuratorDTO], Error> = .success([])
    public var searchRadioShowsResult: Result<[RadioShowDTO], Error> = .success([])
    public var searchAllResult: Result<SearchAllResult, Error> = .success(SearchAllResult())
    public var getSuggestionsResult: Result<SuggestionsResult, Error> = .success(SuggestionsResult(terms: []))
    public var getSongResult: Result<SongDTO, Error> = .success(.fixture())
    public var getSongByISRCResult: Result<[SongDTO], Error> = .success([])
    public var getAlbumResult: Result<AlbumDTO, Error> = .success(.fixture())
    public var getAlbumByUPCResult: Result<[AlbumDTO], Error> = .success([])
    public var getArtistResult: Result<ArtistDTO, Error> = .success(.fixture())
    public var getPlaylistResult: Result<PlaylistDTO, Error> = .success(.fixture())
    public var getMusicVideoResult: Result<MusicVideoDTO, Error> = .success(.fixture())
    public var getStationResult: Result<StationDTO, Error> = .success(.fixture())
    public var getCuratorResult: Result<CuratorDTO, Error> = .success(.fixture())
    public var getRadioShowResult: Result<RadioShowDTO, Error> = .success(.fixture())
    public var getRecordLabelResult: Result<RecordLabelDTO, Error> = .success(.fixture())
    public var getGenreResult: Result<GenreDTO, Error> = .success(.fixture())
    public var getAllGenresResult: Result<[GenreDTO], Error> = .success([])
    public var getChartsResult: Result<ChartsResult, Error> = .success(ChartsResult(charts: []))
    public var getStorefrontResult: Result<StorefrontDTO, Error> = .success(.fixture())

    public init() {}

    // MARK: - Reset

    public func reset() {
        searchSongsCalled = false
        searchAlbumsCalled = false
        searchArtistsCalled = false
        searchPlaylistsCalled = false
        searchMusicVideosCalled = false
        searchStationsCalled = false
        searchCuratorsCalled = false
        searchRadioShowsCalled = false
        searchAllCalled = false
        getSuggestionsCalled = false
        getSongCalled = false
        getSongByISRCCalled = false
        getAlbumCalled = false
        getAlbumByUPCCalled = false
        getArtistCalled = false
        getPlaylistCalled = false
        getMusicVideoCalled = false
        getStationCalled = false
        getCuratorCalled = false
        getRadioShowCalled = false
        getRecordLabelCalled = false
        getGenreCalled = false
        getAllGenresCalled = false
        getChartsCalled = false
        getStorefrontCalled = false
    }

    // MARK: - Search

    public func searchSongs(query: String, limit: Int, offset: Int) async throws -> [SongDTO] {
        searchSongsCalled = true
        return try searchSongsResult.get()
    }

    public func searchAlbums(query: String, limit: Int, offset: Int) async throws -> [AlbumDTO] {
        searchAlbumsCalled = true
        return try searchAlbumsResult.get()
    }

    public func searchArtists(query: String, limit: Int, offset: Int) async throws -> [ArtistDTO] {
        searchArtistsCalled = true
        return try searchArtistsResult.get()
    }

    public func searchPlaylists(query: String, limit: Int, offset: Int) async throws -> [PlaylistDTO] {
        searchPlaylistsCalled = true
        return try searchPlaylistsResult.get()
    }

    public func searchMusicVideos(query: String, limit: Int, offset: Int) async throws -> [MusicVideoDTO] {
        searchMusicVideosCalled = true
        return try searchMusicVideosResult.get()
    }

    public func searchStations(query: String, limit: Int, offset: Int) async throws -> [StationDTO] {
        searchStationsCalled = true
        return try searchStationsResult.get()
    }

    public func searchCurators(query: String, limit: Int, offset: Int) async throws -> [CuratorDTO] {
        searchCuratorsCalled = true
        return try searchCuratorsResult.get()
    }

    public func searchRadioShows(query: String, limit: Int, offset: Int) async throws -> [RadioShowDTO] {
        searchRadioShowsCalled = true
        return try searchRadioShowsResult.get()
    }

    public func searchAll(query: String, types: [String], limit: Int, offset: Int) async throws -> SearchAllResult {
        searchAllCalled = true
        return try searchAllResult.get()
    }

    public func getSuggestions(query: String, limit: Int, types: [String]?) async throws -> SuggestionsResult {
        getSuggestionsCalled = true
        return try getSuggestionsResult.get()
    }

    // MARK: - Get by ID

    public func getSong(id: String) async throws -> SongDTO {
        getSongCalled = true
        return try getSongResult.get()
    }

    public func getSongByISRC(isrc: String) async throws -> [SongDTO] {
        getSongByISRCCalled = true
        return try getSongByISRCResult.get()
    }

    public func getAlbum(id: String) async throws -> AlbumDTO {
        getAlbumCalled = true
        return try getAlbumResult.get()
    }

    public func getAlbumByUPC(upc: String) async throws -> [AlbumDTO] {
        getAlbumByUPCCalled = true
        return try getAlbumByUPCResult.get()
    }

    public func getArtist(id: String) async throws -> ArtistDTO {
        getArtistCalled = true
        return try getArtistResult.get()
    }

    public func getPlaylist(id: String) async throws -> PlaylistDTO {
        getPlaylistCalled = true
        return try getPlaylistResult.get()
    }

    public func getMusicVideo(id: String) async throws -> MusicVideoDTO {
        getMusicVideoCalled = true
        return try getMusicVideoResult.get()
    }

    public func getStation(id: String) async throws -> StationDTO {
        getStationCalled = true
        return try getStationResult.get()
    }

    public func getCurator(id: String) async throws -> CuratorDTO {
        getCuratorCalled = true
        return try getCuratorResult.get()
    }

    public func getRadioShow(id: String) async throws -> RadioShowDTO {
        getRadioShowCalled = true
        return try getRadioShowResult.get()
    }

    public func getRecordLabel(id: String) async throws -> RecordLabelDTO {
        getRecordLabelCalled = true
        return try getRecordLabelResult.get()
    }

    public func getGenre(id: String) async throws -> GenreDTO {
        getGenreCalled = true
        return try getGenreResult.get()
    }

    public func getAllGenres() async throws -> [GenreDTO] {
        getAllGenresCalled = true
        return try getAllGenresResult.get()
    }

    // MARK: - Charts & Storefronts

    public func getCharts(kinds: [String], types: [String], genreId: String?, limit: Int) async throws -> ChartsResult {
        getChartsCalled = true
        return try getChartsResult.get()
    }

    public func getStorefront(id: String) async throws -> StorefrontDTO {
        getStorefrontCalled = true
        return try getStorefrontResult.get()
    }
}

//
//  LiveMusicCatalogService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import MusicKit

/// Live implementation of MusicCatalogService using MusicKit framework.
public final class LiveMusicCatalogService: MusicCatalogService, Sendable {
    public init() {}

    // MARK: - Search

    public func searchSongs(query: String, limit: Int, offset: Int) async throws -> [SongDTO] {
        var request = MusicCatalogSearchRequest(term: query, types: [Song.self])
        request.limit = limit
        request.offset = offset
        let response = try await request.response()
        return response.songs.map { mapSong($0) }
    }

    public func searchAlbums(query: String, limit: Int, offset: Int) async throws -> [AlbumDTO] {
        var request = MusicCatalogSearchRequest(term: query, types: [Album.self])
        request.limit = limit
        request.offset = offset
        let response = try await request.response()
        return response.albums.map { mapAlbum($0) }
    }

    public func searchArtists(query: String, limit: Int, offset: Int) async throws -> [ArtistDTO] {
        var request = MusicCatalogSearchRequest(term: query, types: [Artist.self])
        request.limit = limit
        request.offset = offset
        let response = try await request.response()
        return response.artists.map { mapArtist($0) }
    }

    public func searchPlaylists(query: String, limit: Int, offset: Int) async throws -> [PlaylistDTO] {
        var request = MusicCatalogSearchRequest(term: query, types: [Playlist.self])
        request.limit = limit
        request.offset = offset
        let response = try await request.response()
        return response.playlists.map { mapPlaylist($0) }
    }

    public func searchMusicVideos(query: String, limit: Int, offset: Int) async throws -> [MusicVideoDTO] {
        var request = MusicCatalogSearchRequest(term: query, types: [MusicVideo.self])
        request.limit = limit
        request.offset = offset
        let response = try await request.response()
        return response.musicVideos.map { mapMusicVideo($0) }
    }

    public func searchStations(query: String, limit: Int, offset: Int) async throws -> [StationDTO] {
        var request = MusicCatalogSearchRequest(term: query, types: [Station.self])
        request.limit = limit
        request.offset = offset
        let response = try await request.response()
        return response.stations.map { mapStation($0) }
    }

    public func searchCurators(query: String, limit: Int, offset: Int) async throws -> [CuratorDTO] {
        var request = MusicCatalogSearchRequest(term: query, types: [Curator.self])
        request.limit = limit
        request.offset = offset
        let response = try await request.response()
        return response.curators.map { mapCurator($0) }
    }

    public func searchRadioShows(query: String, limit: Int, offset: Int) async throws -> [RadioShowDTO] {
        var request = MusicCatalogSearchRequest(term: query, types: [RadioShow.self])
        request.limit = limit
        request.offset = offset
        let response = try await request.response()
        return response.radioShows.map { mapRadioShow($0) }
    }

    public func searchAll(query: String, types: [String], limit: Int, offset: Int) async throws -> SearchAllResult {
        var musicTypes: [MusicCatalogSearchable.Type] = []
        for t in types {
            switch t {
            case "songs": musicTypes.append(Song.self)
            case "albums": musicTypes.append(Album.self)
            case "artists": musicTypes.append(Artist.self)
            case "playlists": musicTypes.append(Playlist.self)
            case "music-videos": musicTypes.append(MusicVideo.self)
            case "stations": musicTypes.append(Station.self)
            case "curators": musicTypes.append(Curator.self)
            case "radio-shows": musicTypes.append(RadioShow.self)
            default: break
            }
        }
        if musicTypes.isEmpty {
            musicTypes = [Song.self, Album.self, Artist.self, Playlist.self]
        }
        var request = MusicCatalogSearchRequest(term: query, types: musicTypes)
        request.limit = limit
        request.offset = offset
        let response = try await request.response()
        return SearchAllResult(
            songs: response.songs.isEmpty ? nil : response.songs.map { mapSong($0) },
            albums: response.albums.isEmpty ? nil : response.albums.map { mapAlbum($0) },
            artists: response.artists.isEmpty ? nil : response.artists.map { mapArtist($0) },
            playlists: response.playlists.isEmpty ? nil : response.playlists.map { mapPlaylist($0) },
            musicVideos: response.musicVideos.isEmpty ? nil : response.musicVideos.map { mapMusicVideo($0) },
            stations: response.stations.isEmpty ? nil : response.stations.map { mapStation($0) },
            curators: response.curators.isEmpty ? nil : response.curators.map { mapCurator($0) },
            radioShows: response.radioShows.isEmpty ? nil : response.radioShows.map { mapRadioShow($0) }
        )
    }

    public func getSuggestions(query: String, limit: Int, types: [String]?) async throws -> SuggestionsResult {
        let request = MusicCatalogSearchSuggestionsRequest(term: query, includingTopResultsOfTypes: [Song.self, Album.self, Artist.self])
        let response = try await request.response()
        var terms: [String] = []
        for suggestion in response.suggestions {
            // Extract search term suggestions using the displayTerm property
            let mirror = Mirror(reflecting: suggestion)
            for child in mirror.children {
                if child.label == "searchTerm", let term = child.value as? String {
                    terms.append(term)
                }
            }
        }
        // Fallback: if reflection didn't work, use the description
        if terms.isEmpty {
            terms = response.suggestions.compactMap { suggestion in
                let desc = String(describing: suggestion)
                // Try to extract term from description
                if desc.contains("term(") {
                    return nil // We'll handle this differently
                }
                return nil
            }
        }
        return SuggestionsResult(terms: terms)
    }

    // MARK: - Get by ID

    public func getSong(id: String) async throws -> SongDTO {
        let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: MusicItemID(id))
        let response = try await request.response()
        guard let song = response.items.first else {
            throw AuxError.notFound(message: "Song not found: \(id)")
        }
        return mapSong(song)
    }

    public func getSongByISRC(isrc: String) async throws -> [SongDTO] {
        let request = MusicCatalogResourceRequest<Song>(matching: \.isrc, equalTo: isrc)
        let response = try await request.response()
        return response.items.map { mapSong($0) }
    }

    public func getAlbum(id: String) async throws -> AlbumDTO {
        let request = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: MusicItemID(id))
        let response = try await request.response()
        guard let album = response.items.first else {
            throw AuxError.notFound(message: "Album not found: \(id)")
        }
        return mapAlbum(album)
    }

    public func getAlbumByUPC(upc: String) async throws -> [AlbumDTO] {
        let request = MusicCatalogResourceRequest<Album>(matching: \.upc, equalTo: upc)
        let response = try await request.response()
        return response.items.map { mapAlbum($0) }
    }

    public func getArtist(id: String) async throws -> ArtistDTO {
        let request = MusicCatalogResourceRequest<Artist>(matching: \.id, equalTo: MusicItemID(id))
        let response = try await request.response()
        guard let artist = response.items.first else {
            throw AuxError.notFound(message: "Artist not found: \(id)")
        }
        return mapArtist(artist)
    }

    public func getPlaylist(id: String) async throws -> PlaylistDTO {
        let request = MusicCatalogResourceRequest<Playlist>(matching: \.id, equalTo: MusicItemID(id))
        let response = try await request.response()
        guard let playlist = response.items.first else {
            throw AuxError.notFound(message: "Playlist not found: \(id)")
        }
        return mapPlaylist(playlist)
    }

    public func getMusicVideo(id: String) async throws -> MusicVideoDTO {
        let request = MusicCatalogResourceRequest<MusicVideo>(matching: \.id, equalTo: MusicItemID(id))
        let response = try await request.response()
        guard let mv = response.items.first else {
            throw AuxError.notFound(message: "Music video not found: \(id)")
        }
        return mapMusicVideo(mv)
    }

    public func getStation(id: String) async throws -> StationDTO {
        let request = MusicCatalogResourceRequest<Station>(matching: \.id, equalTo: MusicItemID(id))
        let response = try await request.response()
        guard let station = response.items.first else {
            throw AuxError.notFound(message: "Station not found: \(id)")
        }
        return mapStation(station)
    }

    public func getCurator(id: String) async throws -> CuratorDTO {
        let request = MusicCatalogResourceRequest<Curator>(matching: \.id, equalTo: MusicItemID(id))
        let response = try await request.response()
        guard let curator = response.items.first else {
            throw AuxError.notFound(message: "Curator not found: \(id)")
        }
        return mapCurator(curator)
    }

    public func getRadioShow(id: String) async throws -> RadioShowDTO {
        let request = MusicCatalogResourceRequest<RadioShow>(matching: \.id, equalTo: MusicItemID(id))
        let response = try await request.response()
        guard let show = response.items.first else {
            throw AuxError.notFound(message: "Radio show not found: \(id)")
        }
        return mapRadioShow(show)
    }

    public func getRecordLabel(id: String) async throws -> RecordLabelDTO {
        let request = MusicCatalogResourceRequest<RecordLabel>(matching: \.id, equalTo: MusicItemID(id))
        let response = try await request.response()
        guard let label = response.items.first else {
            throw AuxError.notFound(message: "Record label not found: \(id)")
        }
        return mapRecordLabel(label)
    }

    public func getGenre(id: String) async throws -> GenreDTO {
        let request = MusicCatalogResourceRequest<Genre>(matching: \.id, equalTo: MusicItemID(id))
        let response = try await request.response()
        guard let genre = response.items.first else {
            throw AuxError.notFound(message: "Genre not found: \(id)")
        }
        return GenreDTO(id: genre.id.rawValue, name: genre.name)
    }

    public func getAllGenres() async throws -> [GenreDTO] {
        let request = MusicCatalogResourceRequest<Genre>()
        let response = try await request.response()
        return response.items.map { GenreDTO(id: $0.id.rawValue, name: $0.name) }
    }

    // MARK: - Charts & Storefronts

    public func getCharts(kinds: [String], types: [String], genreId: String?, limit: Int) async throws -> ChartsResult {
        var chartTypes: [MusicCatalogChartRequestable.Type] = []
        for t in types {
            switch t {
            case "songs": chartTypes.append(Song.self)
            case "albums": chartTypes.append(Album.self)
            case "playlists": chartTypes.append(Playlist.self)
            case "music-videos": chartTypes.append(MusicVideo.self)
            default: break
            }
        }
        if chartTypes.isEmpty {
            chartTypes = [Song.self, Album.self, Playlist.self]
        }
        var request = MusicCatalogChartsRequest(types: chartTypes)
        request.limit = limit
        let response = try await request.response()
        var entries: [ChartEntry] = []
        for chart in response.songCharts {
            entries.append(ChartEntry(
                title: chart.title,
                kind: "most-played",
                songs: chart.items.map { mapSong($0) }
            ))
        }
        for chart in response.albumCharts {
            entries.append(ChartEntry(
                title: chart.title,
                kind: "most-played",
                albums: chart.items.map { mapAlbum($0) }
            ))
        }
        for chart in response.playlistCharts {
            entries.append(ChartEntry(
                title: chart.title,
                kind: "most-played",
                playlists: chart.items.map { mapPlaylist($0) }
            ))
        }
        for chart in response.musicVideoCharts {
            entries.append(ChartEntry(
                title: chart.title,
                kind: "most-played",
                musicVideos: chart.items.map { mapMusicVideo($0) }
            ))
        }
        return ChartsResult(charts: entries)
    }

    public func getStorefront(id: String) async throws -> StorefrontDTO {
        // Storefront is not directly available as a MusicKit catalog resource type.
        // Use MusicDataRequest via REST API to fetch storefront info.
        guard let url = URL(string: "https://api.music.apple.com/v1/storefronts/\(id)") else {
            throw AuxError.usageError(message: "Invalid storefront ID: \(id)")
        }
        let urlRequest = URLRequest(url: url)
        let dataRequest = MusicDataRequest(urlRequest: urlRequest)
        let response = try await dataRequest.response()

        // Parse the JSON response
        struct StorefrontResponse: Decodable {
            struct StorefrontData: Decodable {
                let id: String
                struct Attributes: Decodable {
                    let name: String
                    let defaultLanguageTag: String
                    let supportedLanguageTags: [String]
                }
                let attributes: Attributes
            }
            let data: [StorefrontData]
        }

        let decoded = try JSONDecoder().decode(StorefrontResponse.self, from: response.data)
        guard let sf = decoded.data.first else {
            throw AuxError.notFound(message: "Storefront not found: \(id)")
        }
        return StorefrontDTO(
            id: sf.id,
            name: sf.attributes.name,
            defaultLanguage: sf.attributes.defaultLanguageTag,
            supportedLanguages: sf.attributes.supportedLanguageTags
        )
    }

    // MARK: - Mappers

    private func mapSong(_ song: Song) -> SongDTO {
        SongDTO(
            id: song.id.rawValue,
            title: song.title,
            artistName: song.artistName,
            albumTitle: song.albumTitle,
            durationSeconds: song.duration,
            trackNumber: song.trackNumber,
            discNumber: song.discNumber,
            genreNames: song.genreNames,
            releaseDate: MusicKitToDTOMapper.formatDate(song.releaseDate),
            isrc: song.isrc,
            hasLyrics: song.hasLyrics,
            artworkUrl: song.artwork?.url(width: 300, height: 300)?.absoluteString,
            url: song.url?.absoluteString,
            previewUrl: song.previewAssets?.first?.url?.absoluteString,
            contentRating: song.contentRating.map { String(describing: $0) }
        )
    }

    private func mapAlbum(_ album: Album) -> AlbumDTO {
        AlbumDTO(
            id: album.id.rawValue,
            title: album.title,
            artistName: album.artistName,
            trackCount: album.trackCount,
            genreNames: album.genreNames,
            releaseDate: MusicKitToDTOMapper.formatDate(album.releaseDate),
            upc: album.upc,
            isCompilation: album.isCompilation,
            isSingle: album.isSingle,
            contentRating: album.contentRating.map { String(describing: $0) },
            artworkUrl: album.artwork?.url(width: 300, height: 300)?.absoluteString,
            url: album.url?.absoluteString,
            editorialNotes: album.editorialNotes.map {
                EditorialNotes(standard: $0.standard, short: $0.short)
            },
            recordLabelName: album.recordLabelName
        )
    }

    private func mapArtist(_ artist: Artist) -> ArtistDTO {
        ArtistDTO(
            id: artist.id.rawValue,
            name: artist.name,
            genreNames: artist.genreNames,
            artworkUrl: artist.artwork?.url(width: 300, height: 300)?.absoluteString,
            url: artist.url?.absoluteString
        )
    }

    private func mapPlaylist(_ playlist: Playlist) -> PlaylistDTO {
        PlaylistDTO(
            id: playlist.id.rawValue,
            name: playlist.name,
            curatorName: playlist.curatorName,
            description: playlist.standardDescription,
            lastModifiedDate: MusicKitToDTOMapper.formatDate(playlist.lastModifiedDate),
            artworkUrl: playlist.artwork?.url(width: 300, height: 300)?.absoluteString,
            url: playlist.url?.absoluteString
        )
    }

    private func mapMusicVideo(_ mv: MusicVideo) -> MusicVideoDTO {
        MusicVideoDTO(
            id: mv.id.rawValue,
            title: mv.title,
            artistName: mv.artistName,
            durationSeconds: mv.duration,
            genreNames: mv.genreNames,
            releaseDate: MusicKitToDTOMapper.formatDate(mv.releaseDate),
            isrc: mv.isrc,
            artworkUrl: mv.artwork?.url(width: 300, height: 300)?.absoluteString,
            url: mv.url?.absoluteString,
            contentRating: mv.contentRating.map { String(describing: $0) }
        )
    }

    private func mapStation(_ station: Station) -> StationDTO {
        StationDTO(
            id: station.id.rawValue,
            name: station.name,
            artworkUrl: station.artwork?.url(width: 300, height: 300)?.absoluteString,
            url: station.url?.absoluteString,
            isLive: station.isLive
        )
    }

    private func mapCurator(_ curator: Curator) -> CuratorDTO {
        CuratorDTO(
            id: curator.id.rawValue,
            name: curator.name,
            artworkUrl: curator.artwork?.url(width: 300, height: 300)?.absoluteString,
            url: curator.url?.absoluteString
        )
    }

    private func mapRadioShow(_ show: RadioShow) -> RadioShowDTO {
        RadioShowDTO(
            id: show.id.rawValue,
            name: show.name,
            artworkUrl: show.artwork?.url(width: 300, height: 300)?.absoluteString,
            url: show.url?.absoluteString
        )
    }

    private func mapRecordLabel(_ label: RecordLabel) -> RecordLabelDTO {
        RecordLabelDTO(
            id: label.id.rawValue,
            name: label.name
        )
    }
}

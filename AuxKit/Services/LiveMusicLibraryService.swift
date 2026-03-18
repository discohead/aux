//
//  LiveMusicLibraryService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import MusicKit

/// Live implementation of MusicLibraryService using MusicKit's MusicLibraryRequest (macOS 14+).
@available(macOS 14.0, *)
public final class LiveMusicLibraryService: MusicLibraryService, Sendable {
    public init() {}

    public func getSongs(limit: Int, offset: Int, sort: String?, filters: LibrarySongFilters?) async throws -> [SongDTO] {
        var request = MusicLibraryRequest<Song>()
        request.limit = limit
        if let filters = filters {
            if let title = filters.title {
                request.filter(matching: \.title, equalTo: title)
            }
            if let artist = filters.artist {
                request.filter(matching: \.artistName, equalTo: artist)
            }
            if let album = filters.album {
                request.filter(matching: \.albumTitle, equalTo: album)
            }
        }
        if let sort = sort {
            switch sort {
            case "title": request.sort(by: \.title, ascending: true)
            case "-title": request.sort(by: \.title, ascending: false)
            case "artist": request.sort(by: \.artistName, ascending: true)
            case "-artist": request.sort(by: \.artistName, ascending: false)
            case "album": request.sort(by: \.albumTitle, ascending: true)
            case "-album": request.sort(by: \.albumTitle, ascending: false)
            case "play-count": request.sort(by: \.playCount, ascending: true)
            case "-play-count": request.sort(by: \.playCount, ascending: false)
            default: break
            }
        }
        let response = try await request.response()
        return response.items.dropFirst(offset).prefix(limit).map { song in
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
                artworkUrl: song.artwork?.url(width: 300, height: 300)?.absoluteString
            )
        }
    }

    public func getAlbums(limit: Int, offset: Int, sort: String?, filters: LibraryAlbumFilters?) async throws -> [AlbumDTO] {
        var request = MusicLibraryRequest<Album>()
        request.limit = limit
        if let filters = filters {
            if let title = filters.title {
                request.filter(matching: \.title, equalTo: title)
            }
            if let artist = filters.artist {
                request.filter(matching: \.artistName, equalTo: artist)
            }
        }
        if let sort = sort {
            switch sort {
            case "title": request.sort(by: \.title, ascending: true)
            case "-title": request.sort(by: \.title, ascending: false)
            case "artist": request.sort(by: \.artistName, ascending: true)
            case "-artist": request.sort(by: \.artistName, ascending: false)
            default: break
            }
        }
        let response = try await request.response()
        return response.items.dropFirst(offset).prefix(limit).map { album in
            AlbumDTO(
                id: album.id.rawValue,
                title: album.title,
                artistName: album.artistName,
                trackCount: album.trackCount,
                genreNames: album.genreNames,
                releaseDate: MusicKitToDTOMapper.formatDate(album.releaseDate),
                artworkUrl: album.artwork?.url(width: 300, height: 300)?.absoluteString
            )
        }
    }

    public func getArtists(limit: Int, offset: Int, sort: String?, filterName: String?) async throws -> [ArtistDTO] {
        var request = MusicLibraryRequest<Artist>()
        request.limit = limit
        if let name = filterName {
            request.filter(matching: \.name, equalTo: name)
        }
        if let sort = sort {
            switch sort {
            case "name": request.sort(by: \.name, ascending: true)
            case "-name": request.sort(by: \.name, ascending: false)
            default: break
            }
        }
        let response = try await request.response()
        return response.items.dropFirst(offset).prefix(limit).map { artist in
            ArtistDTO(
                id: artist.id.rawValue,
                name: artist.name,
                artworkUrl: artist.artwork?.url(width: 300, height: 300)?.absoluteString
            )
        }
    }

    public func getPlaylists(limit: Int, offset: Int, sort: String?) async throws -> [PlaylistDTO] {
        var request = MusicLibraryRequest<Playlist>()
        request.limit = limit
        if let sort = sort {
            switch sort {
            case "name": request.sort(by: \.name, ascending: true)
            case "-name": request.sort(by: \.name, ascending: false)
            default: break
            }
        }
        let response = try await request.response()
        return response.items.dropFirst(offset).prefix(limit).map { playlist in
            PlaylistDTO(
                id: playlist.id.rawValue,
                name: playlist.name,
                curatorName: playlist.curatorName,
                description: playlist.standardDescription,
                lastModifiedDate: MusicKitToDTOMapper.formatDate(playlist.lastModifiedDate),
                artworkUrl: playlist.artwork?.url(width: 300, height: 300)?.absoluteString
            )
        }
    }

    public func getMusicVideos(limit: Int, offset: Int) async throws -> [MusicVideoDTO] {
        var request = MusicLibraryRequest<MusicVideo>()
        request.limit = limit
        let response = try await request.response()
        return response.items.dropFirst(offset).prefix(limit).map { mv in
            MusicVideoDTO(
                id: mv.id.rawValue,
                title: mv.title,
                artistName: mv.artistName,
                durationSeconds: mv.duration,
                genreNames: mv.genreNames,
                releaseDate: MusicKitToDTOMapper.formatDate(mv.releaseDate),
                artworkUrl: mv.artwork?.url(width: 300, height: 300)?.absoluteString
            )
        }
    }

    public func search(query: String, types: [String], limit: Int) async throws -> LibrarySearchResult {
        var request = MusicLibrarySearchRequest(term: query, types: [Song.self, Album.self, Artist.self, Playlist.self])
        request.limit = limit
        let response = try await request.response()

        let songs: [SongDTO]? = response.songs.isEmpty ? nil : response.songs.map { song in
            SongDTO(
                id: song.id.rawValue,
                title: song.title,
                artistName: song.artistName,
                genreNames: song.genreNames
            )
        }
        let albums: [AlbumDTO]? = response.albums.isEmpty ? nil : response.albums.map { album in
            AlbumDTO(
                id: album.id.rawValue,
                title: album.title,
                artistName: album.artistName,
                genreNames: album.genreNames
            )
        }
        let artists: [ArtistDTO]? = response.artists.isEmpty ? nil : response.artists.map { artist in
            ArtistDTO(
                id: artist.id.rawValue,
                name: artist.name
            )
        }
        let playlists: [PlaylistDTO]? = response.playlists.isEmpty ? nil : response.playlists.map { playlist in
            PlaylistDTO(
                id: playlist.id.rawValue,
                name: playlist.name
            )
        }

        return LibrarySearchResult(
            songs: songs,
            albums: albums,
            artists: artists,
            playlists: playlists
        )
    }
}

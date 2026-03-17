//
//  AppleScriptBridgeProtocol.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Protocol defining operations for controlling Apple Music via AppleScript/JXA bridge.
public protocol AppleScriptBridgeProtocol: Sendable {

    // MARK: - Playback

    func play(trackId: Int?) async throws -> NowPlayingDTO
    func pause() async throws
    func stop() async throws
    func nextTrack() async throws -> NowPlayingDTO
    func previousTrack() async throws -> NowPlayingDTO
    func getNowPlaying() async throws -> NowPlayingDTO
    func getPlayerStatus() async throws -> PlayerStatusResult
    func seek(position: Double) async throws
    func setVolume(_ volume: Double) async throws
    func setShuffle(_ enabled: Bool) async throws
    func setRepeat(_ mode: String) async throws

    // MARK: - Tags

    func getTrackTags(trackId: Int) async throws -> TrackTagsDTO
    func setTrackTags(trackId: Int, fields: [String: String]) async throws
    func batchSetTrackTags(trackIds: [Int], fields: [String: String]) async throws

    // MARK: - Lyrics

    func getLyrics(trackId: Int) async throws -> String?
    func setLyrics(trackId: Int, text: String) async throws

    // MARK: - Artwork

    func getArtwork(trackId: Int, index: Int) async throws -> ArtworkResult
    func setArtwork(trackId: Int, imagePath: String) async throws
    func getArtworkCount(trackId: Int) async throws -> Int

    // MARK: - File Info

    func getFileInfo(trackId: Int) async throws -> FileInfoDTO

    // MARK: - Track Management

    func reveal(trackId: Int) async throws -> String
    func deleteTracks(trackIds: [Int]) async throws
    func convertTracks(trackIds: [Int]) async throws -> ConvertResult
    func importFiles(paths: [String], toPlaylist: String?) async throws -> ImportResult

    // MARK: - Play Stats

    func getPlayStats(trackId: Int) async throws -> PlayStatsDTO
    func setPlayStats(trackId: Int, fields: [String: String]) async throws
    func resetPlayStats(trackIds: [Int]) async throws

    // MARK: - Playlist Management

    func listAllPlaylists() async throws -> [PlaylistInfoResult]
    func deletePlaylist(name: String) async throws
    func renamePlaylist(name: String, newName: String) async throws
    func removeTracksFromPlaylist(playlistName: String, trackIds: [Int]) async throws
    func reorderPlaylistTracks(playlistName: String, trackIds: [Int]) async throws
    func findDuplicatesInPlaylist(playlistName: String) async throws -> [SongDTO]

    // MARK: - AirPlay

    func listAirPlayDevices() async throws -> AirPlayDeviceResult
    func selectAirPlayDevice(name: String) async throws
    func getCurrentAirPlayDevice() async throws -> String?

    // MARK: - EQ

    func listEQPresets() async throws -> [String]
    func getEQ() async throws -> String?
    func setEQ(preset: String) async throws
}

//
//  MockAppleScriptBridge.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Mock implementation of AppleScriptBridgeProtocol for testing.
public final class MockAppleScriptBridge: AppleScriptBridgeProtocol, @unchecked Sendable {

    // MARK: - Call Tracking

    public var playCalled = false
    public var pauseCalled = false
    public var stopCalled = false
    public var nextTrackCalled = false
    public var previousTrackCalled = false
    public var getNowPlayingCalled = false
    public var getPlayerStatusCalled = false
    public var seekCalled = false
    public var setVolumeCalled = false
    public var setShuffleCalled = false
    public var setRepeatCalled = false
    public var getTrackTagsCalled = false
    public var setTrackTagsCalled = false
    public var batchSetTrackTagsCalled = false
    public var getLyricsCalled = false
    public var setLyricsCalled = false
    public var getArtworkCalled = false
    public var setArtworkCalled = false
    public var getArtworkCountCalled = false
    public var getFileInfoCalled = false
    public var revealCalled = false
    public var deleteTracksCalled = false
    public var convertTracksCalled = false
    public var importFilesCalled = false
    public var getPlayStatsCalled = false
    public var setPlayStatsCalled = false
    public var resetPlayStatsCalled = false
    public var listAllPlaylistsCalled = false
    public var deletePlaylistCalled = false
    public var renamePlaylistCalled = false
    public var removeTracksFromPlaylistCalled = false
    public var reorderPlaylistTracksCalled = false
    public var findDuplicatesInPlaylistCalled = false
    public var listAirPlayDevicesCalled = false
    public var selectAirPlayDeviceCalled = false
    public var getCurrentAirPlayDeviceCalled = false
    public var listEQPresetsCalled = false
    public var getEQCalled = false
    public var setEQCalled = false

    // MARK: - Configurable Results

    public var playResult: Result<NowPlayingDTO, Error> = .success(.fixture())
    public var pauseResult: Result<Void, Error> = .success(())
    public var stopResult: Result<Void, Error> = .success(())
    public var nextTrackResult: Result<NowPlayingDTO, Error> = .success(.fixture())
    public var previousTrackResult: Result<NowPlayingDTO, Error> = .success(.fixture())
    public var getNowPlayingResult: Result<NowPlayingDTO, Error> = .success(.fixture())
    public var getPlayerStatusResult: Result<PlayerStatusResult, Error> = .success(PlayerStatusResult(state: "playing"))
    public var seekResult: Result<Void, Error> = .success(())
    public var setVolumeResult: Result<Void, Error> = .success(())
    public var setShuffleResult: Result<Void, Error> = .success(())
    public var setRepeatResult: Result<Void, Error> = .success(())
    public var getTrackTagsResult: Result<TrackTagsDTO, Error> = .success(.fixture())
    public var setTrackTagsResult: Result<Void, Error> = .success(())
    public var batchSetTrackTagsResult: Result<Void, Error> = .success(())
    public var getLyricsResult: Result<String?, Error> = .success(nil)
    public var setLyricsResult: Result<Void, Error> = .success(())
    public var getArtworkResult: Result<ArtworkResult, Error> = .success(ArtworkResult(databaseId: 1, artworkCount: 0))
    public var setArtworkResult: Result<Void, Error> = .success(())
    public var getArtworkCountResult: Result<Int, Error> = .success(0)
    public var getFileInfoResult: Result<FileInfoDTO, Error> = .success(.fixture())
    public var revealResult: Result<String, Error> = .success("/path/to/file")
    public var deleteTracksResult: Result<Void, Error> = .success(())
    public var convertTracksResult: Result<ConvertResult, Error> = .success(ConvertResult(converted: true, tracks: []))
    public var importFilesResult: Result<ImportResult, Error> = .success(ImportResult(imported: true, fileCount: 0))
    public var getPlayStatsResult: Result<PlayStatsDTO, Error> = .success(.fixture())
    public var setPlayStatsResult: Result<Void, Error> = .success(())
    public var resetPlayStatsResult: Result<Void, Error> = .success(())
    public var listAllPlaylistsResult: Result<[PlaylistInfoResult], Error> = .success([])
    public var deletePlaylistResult: Result<Void, Error> = .success(())
    public var renamePlaylistResult: Result<Void, Error> = .success(())
    public var removeTracksFromPlaylistResult: Result<Void, Error> = .success(())
    public var reorderPlaylistTracksResult: Result<Void, Error> = .success(())
    public var findDuplicatesInPlaylistResult: Result<[SongDTO], Error> = .success([])
    public var listAirPlayDevicesResult: Result<AirPlayDeviceResult, Error> = .success(AirPlayDeviceResult(devices: []))
    public var selectAirPlayDeviceResult: Result<Void, Error> = .success(())
    public var getCurrentAirPlayDeviceResult: Result<String?, Error> = .success(nil)
    public var listEQPresetsResult: Result<[String], Error> = .success([])
    public var getEQResult: Result<String?, Error> = .success(nil)
    public var setEQResult: Result<Void, Error> = .success(())

    public init() {}

    // MARK: - Reset

    public func reset() {
        playCalled = false
        pauseCalled = false
        stopCalled = false
        nextTrackCalled = false
        previousTrackCalled = false
        getNowPlayingCalled = false
        getPlayerStatusCalled = false
        seekCalled = false
        setVolumeCalled = false
        setShuffleCalled = false
        setRepeatCalled = false
        getTrackTagsCalled = false
        setTrackTagsCalled = false
        batchSetTrackTagsCalled = false
        getLyricsCalled = false
        setLyricsCalled = false
        getArtworkCalled = false
        setArtworkCalled = false
        getArtworkCountCalled = false
        getFileInfoCalled = false
        revealCalled = false
        deleteTracksCalled = false
        convertTracksCalled = false
        importFilesCalled = false
        getPlayStatsCalled = false
        setPlayStatsCalled = false
        resetPlayStatsCalled = false
        listAllPlaylistsCalled = false
        deletePlaylistCalled = false
        renamePlaylistCalled = false
        removeTracksFromPlaylistCalled = false
        reorderPlaylistTracksCalled = false
        findDuplicatesInPlaylistCalled = false
        listAirPlayDevicesCalled = false
        selectAirPlayDeviceCalled = false
        getCurrentAirPlayDeviceCalled = false
        listEQPresetsCalled = false
        getEQCalled = false
        setEQCalled = false
    }

    // MARK: - Playback

    public func play(trackId: Int?) async throws -> NowPlayingDTO {
        playCalled = true
        return try playResult.get()
    }

    public func pause() async throws {
        pauseCalled = true
        try pauseResult.get()
    }

    public func stop() async throws {
        stopCalled = true
        try stopResult.get()
    }

    public func nextTrack() async throws -> NowPlayingDTO {
        nextTrackCalled = true
        return try nextTrackResult.get()
    }

    public func previousTrack() async throws -> NowPlayingDTO {
        previousTrackCalled = true
        return try previousTrackResult.get()
    }

    public func getNowPlaying() async throws -> NowPlayingDTO {
        getNowPlayingCalled = true
        return try getNowPlayingResult.get()
    }

    public func getPlayerStatus() async throws -> PlayerStatusResult {
        getPlayerStatusCalled = true
        return try getPlayerStatusResult.get()
    }

    public func seek(position: Double) async throws {
        seekCalled = true
        try seekResult.get()
    }

    public func setVolume(_ volume: Double) async throws {
        setVolumeCalled = true
        try setVolumeResult.get()
    }

    public func setShuffle(_ enabled: Bool) async throws {
        setShuffleCalled = true
        try setShuffleResult.get()
    }

    public func setRepeat(_ mode: String) async throws {
        setRepeatCalled = true
        try setRepeatResult.get()
    }

    // MARK: - Tags

    public func getTrackTags(trackId: Int) async throws -> TrackTagsDTO {
        getTrackTagsCalled = true
        return try getTrackTagsResult.get()
    }

    public func setTrackTags(trackId: Int, fields: [String: String]) async throws {
        setTrackTagsCalled = true
        try setTrackTagsResult.get()
    }

    public func batchSetTrackTags(trackIds: [Int], fields: [String: String]) async throws {
        batchSetTrackTagsCalled = true
        try batchSetTrackTagsResult.get()
    }

    // MARK: - Lyrics

    public func getLyrics(trackId: Int) async throws -> String? {
        getLyricsCalled = true
        return try getLyricsResult.get()
    }

    public func setLyrics(trackId: Int, text: String) async throws {
        setLyricsCalled = true
        try setLyricsResult.get()
    }

    // MARK: - Artwork

    public func getArtwork(trackId: Int, index: Int) async throws -> ArtworkResult {
        getArtworkCalled = true
        return try getArtworkResult.get()
    }

    public func setArtwork(trackId: Int, imagePath: String) async throws {
        setArtworkCalled = true
        try setArtworkResult.get()
    }

    public func getArtworkCount(trackId: Int) async throws -> Int {
        getArtworkCountCalled = true
        return try getArtworkCountResult.get()
    }

    // MARK: - File Info

    public func getFileInfo(trackId: Int) async throws -> FileInfoDTO {
        getFileInfoCalled = true
        return try getFileInfoResult.get()
    }

    // MARK: - Track Management

    public func reveal(trackId: Int) async throws -> String {
        revealCalled = true
        return try revealResult.get()
    }

    public func deleteTracks(trackIds: [Int]) async throws {
        deleteTracksCalled = true
        try deleteTracksResult.get()
    }

    public func convertTracks(trackIds: [Int]) async throws -> ConvertResult {
        convertTracksCalled = true
        return try convertTracksResult.get()
    }

    public func importFiles(paths: [String], toPlaylist: String?) async throws -> ImportResult {
        importFilesCalled = true
        return try importFilesResult.get()
    }

    // MARK: - Play Stats

    public func getPlayStats(trackId: Int) async throws -> PlayStatsDTO {
        getPlayStatsCalled = true
        return try getPlayStatsResult.get()
    }

    public func setPlayStats(trackId: Int, fields: [String: String]) async throws {
        setPlayStatsCalled = true
        try setPlayStatsResult.get()
    }

    public func resetPlayStats(trackIds: [Int]) async throws {
        resetPlayStatsCalled = true
        try resetPlayStatsResult.get()
    }

    // MARK: - Playlist Management

    public func listAllPlaylists() async throws -> [PlaylistInfoResult] {
        listAllPlaylistsCalled = true
        return try listAllPlaylistsResult.get()
    }

    public func deletePlaylist(name: String) async throws {
        deletePlaylistCalled = true
        try deletePlaylistResult.get()
    }

    public func renamePlaylist(name: String, newName: String) async throws {
        renamePlaylistCalled = true
        try renamePlaylistResult.get()
    }

    public func removeTracksFromPlaylist(playlistName: String, trackIds: [Int]) async throws {
        removeTracksFromPlaylistCalled = true
        try removeTracksFromPlaylistResult.get()
    }

    public func reorderPlaylistTracks(playlistName: String, trackIds: [Int]) async throws {
        reorderPlaylistTracksCalled = true
        try reorderPlaylistTracksResult.get()
    }

    public func findDuplicatesInPlaylist(playlistName: String) async throws -> [SongDTO] {
        findDuplicatesInPlaylistCalled = true
        return try findDuplicatesInPlaylistResult.get()
    }

    // MARK: - AirPlay

    public func listAirPlayDevices() async throws -> AirPlayDeviceResult {
        listAirPlayDevicesCalled = true
        return try listAirPlayDevicesResult.get()
    }

    public func selectAirPlayDevice(name: String) async throws {
        selectAirPlayDeviceCalled = true
        try selectAirPlayDeviceResult.get()
    }

    public func getCurrentAirPlayDevice() async throws -> String? {
        getCurrentAirPlayDeviceCalled = true
        return try getCurrentAirPlayDeviceResult.get()
    }

    // MARK: - EQ

    public func listEQPresets() async throws -> [String] {
        listEQPresetsCalled = true
        return try listEQPresetsResult.get()
    }

    public func getEQ() async throws -> String? {
        getEQCalled = true
        return try getEQResult.get()
    }

    public func setEQ(preset: String) async throws {
        setEQCalled = true
        try setEQResult.get()
    }
}

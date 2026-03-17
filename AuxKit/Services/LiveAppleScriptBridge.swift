//
//  LiveAppleScriptBridge.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Live implementation of AppleScriptBridgeProtocol using NSAppleScript to control Music.app.
///
/// Each method constructs an AppleScript command, executes it, and parses the result.
/// All AppleScript execution is dispatched to the main thread as required by NSAppleScript.
public final class LiveAppleScriptBridge: AppleScriptBridgeProtocol, @unchecked Sendable {
    public init() {}

    // MARK: - Playback

    public func play(trackId: Int?) async throws -> NowPlayingDTO {
        if let trackId = trackId {
            let script = """
            tell application "Music"
                play (every track whose database ID is \(trackId))
            end tell
            """
            try executeScript(script)
        } else {
            try executeScript("tell application \"Music\" to play")
        }
        // When playing a specific track, there can be a brief delay before
        // Music.app reports the new track. Retry once after a short pause.
        do {
            return try await getNowPlaying()
        } catch {
            if trackId != nil {
                try await Task.sleep(nanoseconds: 300_000_000) // 0.3s
                return try await getNowPlaying()
            }
            throw error
        }
    }

    public func pause() async throws {
        try executeScript("tell application \"Music\" to pause")
    }

    public func stop() async throws {
        try executeScript("tell application \"Music\" to stop")
    }

    public func nextTrack() async throws -> NowPlayingDTO {
        try executeScript("tell application \"Music\" to next track")
        return try await getNowPlaying()
    }

    public func previousTrack() async throws -> NowPlayingDTO {
        try executeScript("tell application \"Music\" to previous track")
        return try await getNowPlaying()
    }

    public func getNowPlaying() async throws -> NowPlayingDTO {
        let script = """
        tell application "Music"
            if player state is not stopped then
                set t to current track
                set trackTitle to name of t
                set trackArtist to artist of t
                set trackAlbum to album of t
                set trackDuration to duration of t
                set trackPosition to player position
                set pState to player state as string
                set trackNum to track number of t
                set trackYear to year of t
                set trackGenre to genre of t
                set trackDBID to database ID of t
                return trackTitle & "|||" & trackArtist & "|||" & trackAlbum & "|||" & (trackDuration as string) & "|||" & (trackPosition as string) & "|||" & pState & "|||" & (trackNum as string) & "|||" & (trackYear as string) & "|||" & trackGenre & "|||" & (trackDBID as string)
            else
                error "No track is currently playing"
            end if
        end tell
        """
        let result = try executeScriptWithResult(script)
        let parts = result.components(separatedBy: "|||")
        guard parts.count >= 10 else {
            throw AuxError.appleScriptError(message: "Unexpected response format from Music.app")
        }
        return NowPlayingDTO(
            title: parts[0],
            artistName: parts[1],
            albumTitle: parts[2],
            durationSeconds: Double(parts[3]),
            positionSeconds: Double(parts[4]),
            state: normalizeState(parts[5]),
            trackNumber: Int(parts[6]),
            year: Int(parts[7]),
            genre: parts[8].isEmpty ? nil : parts[8],
            databaseId: Int(parts[9])
        )
    }

    public func getPlayerStatus() async throws -> PlayerStatusResult {
        let script = """
        tell application "Music"
            set pState to player state as string
            set shuffleEnabled to shuffle enabled
            set repeatMode to song repeat as string
            set vol to sound volume
            set airplayOn to AirPlay enabled
            return pState & "|||" & (shuffleEnabled as string) & "|||" & repeatMode & "|||" & (vol as string) & "|||" & (airplayOn as string)
        end tell
        """
        let result = try executeScriptWithResult(script)
        let parts = result.components(separatedBy: "|||")
        guard parts.count >= 5 else {
            throw AuxError.appleScriptError(message: "Unexpected player status format")
        }
        return PlayerStatusResult(
            state: normalizeState(parts[0]),
            shuffleMode: parts[1].lowercased() == "true" ? "songs" : "off",
            repeatMode: parts[2].lowercased(),
            volume: Double(parts[3]),
            airPlayEnabled: parts[4].lowercased() == "true"
        )
    }

    public func seek(position: Double) async throws {
        try executeScript("tell application \"Music\" to set player position to \(position)")
    }

    public func setVolume(_ volume: Double) async throws {
        let intVolume = Int(max(0, min(100, volume)))
        try executeScript("tell application \"Music\" to set sound volume to \(intVolume)")
    }

    public func setShuffle(_ enabled: Bool) async throws {
        try executeScript("tell application \"Music\" to set shuffle enabled to \(enabled)")
    }

    public func setRepeat(_ mode: String) async throws {
        let appleScriptMode: String
        switch mode.lowercased() {
        case "off": appleScriptMode = "off"
        case "one": appleScriptMode = "one"
        case "all": appleScriptMode = "all"
        default: throw AuxError.usageError(message: "Invalid repeat mode: \(mode). Use: off, one, all")
        }
        try executeScript("tell application \"Music\" to set song repeat to \(appleScriptMode)")
    }

    // MARK: - Tags

    public func getTrackTags(trackId: Int) async throws -> TrackTagsDTO {
        let script = """
        tell application "Music"
            set t to (first track whose database ID is \(trackId))
            set output to ""
            set output to output & (database ID of t as string) & "|||"
            set output to output & (persistent ID of t as string) & "|||"
            set output to output & name of t & "|||"
            set output to output & artist of t & "|||"
            set output to output & album artist of t & "|||"
            set output to output & album of t & "|||"
            set output to output & genre of t & "|||"
            set output to output & (year of t as string) & "|||"
            set output to output & composer of t & "|||"
            set output to output & comment of t & "|||"
            set output to output & grouping of t & "|||"
            set output to output & (track number of t as string) & "|||"
            set output to output & (track count of t as string) & "|||"
            set output to output & (disc number of t as string) & "|||"
            set output to output & (disc count of t as string) & "|||"
            set output to output & (compilation of t as string) & "|||"
            set output to output & (enabled of t as string) & "|||"
            set output to output & (rating of t as string) & "|||"
            try
                set output to output & (favorited of t as string) & "|||"
            on error
                try
                    set output to output & (loved of t as string) & "|||"
                on error
                    set output to output & "false" & "|||"
                end try
            end try
            set output to output & (disliked of t as string) & "|||"
            set output to output & (bpm of t as string) & "|||"
            set output to output & (volume adjustment of t as string) & "|||"
            try
                set output to output & (name of EQ preset of t) & "|||"
            on error
                set output to output & "|||"
            end try
            set output to output & (start of t as string) & "|||"
            set output to output & (finish of t as string) & "|||"
            set output to output & sort name of t & "|||"
            set output to output & sort artist of t & "|||"
            set output to output & sort album artist of t & "|||"
            set output to output & sort album of t & "|||"
            set output to output & sort composer of t & "|||"
            set output to output & lyrics of t & "|||"
            set output to output & (duration of t as string) & "|||"
            set output to output & time of t & "|||"
            try
                set output to output & (date added of t as string) & "|||"
            on error
                set output to output & "|||"
            end try
            set output to output & kind of t & "|||"
            return output
        end tell
        """
        let result = try executeScriptWithResult(script)
        let parts = result.components(separatedBy: "|||").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count >= 35 else {
            throw AuxError.appleScriptError(message: "Unexpected track tags format (got \(parts.count) fields)")
        }
        return TrackTagsDTO(
            databaseId: trackId,
            persistentId: emptyToNil(parts[1]),
            name: parts[2],
            artist: emptyToNil(parts[3]),
            albumArtist: emptyToNil(parts[4]),
            album: emptyToNil(parts[5]),
            genre: emptyToNil(parts[6]),
            year: Int(parts[7]),
            composer: emptyToNil(parts[8]),
            comments: emptyToNil(parts[9]),
            grouping: emptyToNil(parts[10]),
            trackNumber: Int(parts[11]),
            trackCount: Int(parts[12]),
            discNumber: Int(parts[13]),
            discCount: Int(parts[14]),
            compilation: parts[15].lowercased() == "true",
            enabled: parts[16].lowercased() == "true",
            rating: Int(parts[17]),
            loved: parts[18].lowercased() == "true",
            disliked: parts[19].lowercased() == "true",
            bpm: Int(parts[20]),
            volumeAdjustment: Int(parts[21]),
            eq: emptyToNil(parts[22]),
            start: Double(parts[23]),
            finish: Double(parts[24]),
            sortName: emptyToNil(parts[25]),
            sortArtist: emptyToNil(parts[26]),
            sortAlbumArtist: emptyToNil(parts[27]),
            sortAlbum: emptyToNil(parts[28]),
            sortComposer: emptyToNil(parts[29]),
            lyrics: emptyToNil(parts[30]),
            duration: Double(parts[31]),
            time: emptyToNil(parts[32]),
            dateAdded: emptyToNil(parts[33]),
            kind: emptyToNil(parts[34])
        )
    }

    public func setTrackTags(trackId: Int, fields: [String: String]) async throws {
        var commands: [String] = []
        for (key, value) in fields {
            let property = tagKeyToAppleScriptProperty(key)
            let escapedValue = value.replacingOccurrences(of: "\"", with: "\\\"")
            commands.append("set \(property) of t to \"\(escapedValue)\"")
        }
        let script = """
        tell application "Music"
            set t to (first track whose database ID is \(trackId))
            \(commands.joined(separator: "\n            "))
        end tell
        """
        try executeScript(script)
    }

    public func batchSetTrackTags(trackIds: [Int], fields: [String: String]) async throws {
        for trackId in trackIds {
            try await setTrackTags(trackId: trackId, fields: fields)
        }
    }

    // MARK: - Lyrics

    public func getLyrics(trackId: Int) async throws -> String? {
        let script = """
        tell application "Music"
            set t to (first track whose database ID is \(trackId))
            return lyrics of t
        end tell
        """
        let result = try executeScriptWithResult(script)
        return result.isEmpty ? nil : result
    }

    public func setLyrics(trackId: Int, text: String) async throws {
        let escapedText = text.replacingOccurrences(of: "\"", with: "\\\"")
        let script = """
        tell application "Music"
            set t to (first track whose database ID is \(trackId))
            set lyrics of t to "\(escapedText)"
        end tell
        """
        try executeScript(script)
    }

    // MARK: - Artwork

    public func getArtwork(trackId: Int, index: Int) async throws -> ArtworkResult {
        let script = """
        tell application "Music"
            set t to (first track whose database ID is \(trackId))
            set artCount to count of artworks of t
            if artCount >= \(index) then
                set a to artwork \(index) of t
                set artFormat to format of a as string
                set artData to raw data of a
                return (artCount as string) & "|||" & artFormat
            else
                return (artCount as string) & "|||"
            end if
        end tell
        """
        let result = try executeScriptWithResult(script)
        let parts = result.components(separatedBy: "|||")
        let artCount = Int(parts[0].trimmingCharacters(in: .whitespaces)) ?? 0
        let format = parts.count > 1 ? emptyToNil(parts[1]) : nil
        return ArtworkResult(
            databaseId: trackId,
            artworkCount: artCount,
            format: format
        )
    }

    public func setArtwork(trackId: Int, imagePath: String) async throws {
        let script = """
        tell application "Music"
            set t to (first track whose database ID is \(trackId))
            set artFile to POSIX file "\(imagePath)"
            set data of artwork 1 of t to (read artFile as data)
        end tell
        """
        try executeScript(script)
    }

    public func getArtworkCount(trackId: Int) async throws -> Int {
        let script = """
        tell application "Music"
            set t to (first track whose database ID is \(trackId))
            return count of artworks of t
        end tell
        """
        let result = try executeScriptWithResult(script)
        return Int(result.trimmingCharacters(in: .whitespaces)) ?? 0
    }

    // MARK: - File Info

    public func getFileInfo(trackId: Int) async throws -> FileInfoDTO {
        let script = """
        tell application "Music"
            set t to (first track whose database ID is \(trackId))
            set loc to ""
            try
                set loc to POSIX path of (location of t as text)
            end try
            set br to bit rate of t
            set sr to sample rate of t
            set sz to size of t
            set k to kind of t
            set dur to duration of t
            set da to date added of t as string
            set dm to modification date of t as string
            return loc & "|||" & (br as string) & "|||" & (sr as string) & "|||" & (sz as string) & "|||" & k & "|||" & (dur as string) & "|||" & da & "|||" & dm
        end tell
        """
        let result = try executeScriptWithResult(script)
        let parts = result.components(separatedBy: "|||")
        guard parts.count >= 8 else {
            throw AuxError.appleScriptError(message: "Unexpected file info format")
        }
        return FileInfoDTO(
            databaseId: trackId,
            location: emptyToNil(parts[0]),
            bitRate: Int(parts[1].trimmingCharacters(in: .whitespaces)),
            sampleRate: Int(parts[2].trimmingCharacters(in: .whitespaces)),
            size: Int(parts[3].trimmingCharacters(in: .whitespaces)),
            kind: emptyToNil(parts[4]),
            duration: Double(parts[5].trimmingCharacters(in: .whitespaces)),
            dateAdded: emptyToNil(parts[6]),
            dateModified: emptyToNil(parts[7])
        )
    }

    // MARK: - Track Management

    public func reveal(trackId: Int) async throws -> String {
        let script = """
        tell application "Music"
            set t to (first track whose database ID is \(trackId))
            try
                set loc to POSIX path of (location of t as text)
                return loc
            on error
                error "Track has no file location"
            end try
        end tell
        """
        return try executeScriptWithResult(script)
    }

    public func deleteTracks(trackIds: [Int]) async throws {
        let idList = trackIds.map { String($0) }.joined(separator: ", ")
        let script = """
        tell application "Music"
            repeat with trackId in {\(idList)}
                set t to (first track whose database ID is trackId)
                delete t
            end repeat
        end tell
        """
        try executeScript(script)
    }

    public func convertTracks(trackIds: [Int]) async throws -> ConvertResult {
        // TODO: Implement track conversion via AppleScript
        throw AuxError.unavailable(message: "Track conversion is not yet implemented")
    }

    public func importFiles(paths: [String], toPlaylist: String?) async throws -> ImportResult {
        let posixPaths = paths.map { "POSIX file \"\($0)\"" }.joined(separator: ", ")
        let script: String
        if let playlist = toPlaylist {
            let escapedPlaylist = playlist.replacingOccurrences(of: "\"", with: "\\\"")
            script = """
            tell application "Music"
                set pl to playlist "\(escapedPlaylist)"
                set imported to {}
                repeat with f in {\(posixPaths)}
                    set newTrack to (add f to pl)
                    set end of imported to (database ID of newTrack as string) & ":" & (name of newTrack)
                end repeat
                return imported as string
            end tell
            """
        } else {
            script = """
            tell application "Music"
                set imported to {}
                repeat with f in {\(posixPaths)}
                    set newTrack to (add f)
                    set end of imported to (database ID of newTrack as string) & ":" & (name of newTrack)
                end repeat
                return imported as string
            end tell
            """
        }
        try executeScript(script)
        return ImportResult(imported: true, fileCount: paths.count)
    }

    // MARK: - Play Stats

    public func getPlayStats(trackId: Int) async throws -> PlayStatsDTO {
        let script = """
        tell application "Music"
            set t to (first track whose database ID is \(trackId))
            set n to name of t
            set a to artist of t
            set pc to played count of t
            set pd to ""
            try
                set pd to played date of t as string
            end try
            set sc to skipped count of t
            set sd to ""
            try
                set sd to skipped date of t as string
            end try
            set r to rating of t
            set l to "false"
            try
                set l to (favorited of t as string)
            on error
                try
                    set l to (loved of t as string)
                end try
            end try
            set d to disliked of t
            return n & "|||" & a & "|||" & (pc as string) & "|||" & pd & "|||" & (sc as string) & "|||" & sd & "|||" & (r as string) & "|||" & l & "|||" & (d as string)
        end tell
        """
        let result = try executeScriptWithResult(script)
        let parts = result.components(separatedBy: "|||")
        guard parts.count >= 9 else {
            throw AuxError.appleScriptError(message: "Unexpected play stats format")
        }
        return PlayStatsDTO(
            databaseId: trackId,
            name: parts[0],
            artist: emptyToNil(parts[1]),
            playedCount: Int(parts[2].trimmingCharacters(in: .whitespaces)),
            playedDate: emptyToNil(parts[3]),
            skippedCount: Int(parts[4].trimmingCharacters(in: .whitespaces)),
            skippedDate: emptyToNil(parts[5]),
            rating: Int(parts[6].trimmingCharacters(in: .whitespaces)),
            loved: parts[7].lowercased().trimmingCharacters(in: .whitespaces) == "true",
            disliked: parts[8].lowercased().trimmingCharacters(in: .whitespaces) == "true"
        )
    }

    public func setPlayStats(trackId: Int, fields: [String: String]) async throws {
        var commands: [String] = []
        for (key, value) in fields {
            switch key {
            case "played_count":
                commands.append("set played count of t to \(value)")
            case "rating":
                commands.append("set rating of t to \(value)")
            case "loved":
                commands.append("set loved of t to \(value)")
            case "disliked":
                commands.append("set disliked of t to \(value)")
            default: break
            }
        }
        let script = """
        tell application "Music"
            set t to (first track whose database ID is \(trackId))
            \(commands.joined(separator: "\n            "))
        end tell
        """
        try executeScript(script)
    }

    public func resetPlayStats(trackIds: [Int]) async throws {
        for trackId in trackIds {
            let script = """
            tell application "Music"
                set t to (first track whose database ID is \(trackId))
                set played count of t to 0
                set skipped count of t to 0
            end tell
            """
            try executeScript(script)
        }
    }

    // MARK: - Playlist Management

    public func listAllPlaylists() async throws -> [PlaylistInfoResult] {
        let script = """
        tell application "Music"
            set output to ""
            repeat with p in (every user playlist)
                set output to output & (id of p as string) & "|||" & name of p & "|||" & (count of tracks of p as string) & "\\n"
            end repeat
            return output
        end tell
        """
        let result = try executeScriptWithResult(script)
        let lines = result.components(separatedBy: "\n").filter { !$0.isEmpty }
        return lines.compactMap { line in
            let parts = line.components(separatedBy: "|||")
            guard parts.count >= 3 else { return nil }
            return PlaylistInfoResult(
                id: parts[0].trimmingCharacters(in: .whitespaces),
                name: parts[1],
                trackCount: Int(parts[2].trimmingCharacters(in: .whitespaces))
            )
        }
    }

    public func deletePlaylist(name: String) async throws {
        let escapedName = name.replacingOccurrences(of: "\"", with: "\\\"")
        try executeScript("""
        tell application "Music"
            delete playlist "\(escapedName)"
        end tell
        """)
    }

    public func renamePlaylist(name: String, newName: String) async throws {
        let escapedName = name.replacingOccurrences(of: "\"", with: "\\\"")
        let escapedNewName = newName.replacingOccurrences(of: "\"", with: "\\\"")
        try executeScript("""
        tell application "Music"
            set name of playlist "\(escapedName)" to "\(escapedNewName)"
        end tell
        """)
    }

    public func removeTracksFromPlaylist(playlistName: String, trackIds: [Int]) async throws {
        let escapedName = playlistName.replacingOccurrences(of: "\"", with: "\\\"")
        for trackId in trackIds.reversed() {
            let script = """
            tell application "Music"
                set pl to playlist "\(escapedName)"
                repeat with i from (count of tracks of pl) to 1 by -1
                    if database ID of track i of pl is \(trackId) then
                        delete track i of pl
                        exit repeat
                    end if
                end repeat
            end tell
            """
            try executeScript(script)
        }
    }

    public func reorderPlaylistTracks(playlistName: String, trackIds: [Int]) async throws {
        // TODO: Implement playlist reordering via AppleScript
        throw AuxError.unavailable(message: "Playlist track reordering is not yet implemented")
    }

    public func findDuplicatesInPlaylist(playlistName: String) async throws -> [SongDTO] {
        // TODO: Implement duplicate detection via AppleScript
        throw AuxError.unavailable(message: "Duplicate detection is not yet implemented")
    }

    // MARK: - AirPlay

    public func listAirPlayDevices() async throws -> AirPlayDeviceResult {
        let script = """
        tell application "Music"
            set output to ""
            repeat with d in (every AirPlay device)
                set output to output & (name of d) & "|||" & (kind of d as string) & "|||" & (selected of d as string) & "\\n"
            end repeat
            return output
        end tell
        """
        let result = try executeScriptWithResult(script)
        let lines = result.components(separatedBy: "\n").filter { !$0.isEmpty }
        let devices = lines.compactMap { line -> AirPlayDevice? in
            let parts = line.components(separatedBy: "|||")
            guard parts.count >= 3 else { return nil }
            return AirPlayDevice(
                name: parts[0],
                kind: emptyToNil(parts[1]),
                active: parts[2].lowercased().trimmingCharacters(in: .whitespaces) == "true"
            )
        }
        return AirPlayDeviceResult(devices: devices)
    }

    public func selectAirPlayDevice(name: String) async throws {
        let escapedName = name.replacingOccurrences(of: "\"", with: "\\\"")
        try executeScript("""
        tell application "Music"
            set selected of AirPlay device "\(escapedName)" to true
        end tell
        """)
    }

    public func getCurrentAirPlayDevice() async throws -> String? {
        let script = """
        tell application "Music"
            set output to ""
            repeat with d in (every AirPlay device)
                if selected of d then
                    set output to name of d
                    exit repeat
                end if
            end repeat
            return output
        end tell
        """
        let result = try executeScriptWithResult(script)
        return result.isEmpty ? nil : result
    }

    // MARK: - EQ

    public func listEQPresets() async throws -> [String] {
        let script = """
        tell application "Music"
            set output to ""
            repeat with p in (every EQ preset)
                set output to output & name of p & "\\n"
            end repeat
            return output
        end tell
        """
        let result = try executeScriptWithResult(script)
        return result.components(separatedBy: "\n").filter { !$0.isEmpty }
    }

    public func getEQ() async throws -> String? {
        // Music.app's AppleScript EQ enabled property is broken (always returns false).
        // Use GUI scripting via System Events to read the actual state.
        let script = """
        tell application "Music" to activate
        delay 0.2
        tell application "System Events"
            tell process "Music"
                -- Open Equalizer window if not already open
                set eqOpen to false
                repeat with w in (every window)
                    if name of w is "Equalizer" then
                        set eqOpen to true
                    end if
                end repeat
                if not eqOpen then
                    click menu item "Equalizer" of menu "Window" of menu bar 1
                    delay 0.3
                end if
                tell window "Equalizer"
                    set isOn to (value of checkbox "On") as integer
                    set presetName to value of pop up button 1
                end tell
                -- Close the window if we opened it
                if not eqOpen then
                    tell window "Equalizer"
                        click button 1
                    end tell
                end if
                if isOn is 1 then
                    return presetName
                else
                    return ""
                end if
            end tell
        end tell
        """
        let result = try executeScriptWithResult(script)
        return result.isEmpty ? nil : result
    }

    public func setEQ(preset: String) async throws {
        // Music.app's AppleScript `set EQ enabled` is broken (-10006).
        // Use GUI scripting via System Events to control the EQ window.
        let escapedPreset = preset.replacingOccurrences(of: "\"", with: "\\\"")
        let script = """
        tell application "Music" to activate
        delay 0.2
        tell application "System Events"
            tell process "Music"
                -- Open Equalizer window if not already open
                set eqOpen to false
                repeat with w in (every window)
                    if name of w is "Equalizer" then
                        set eqOpen to true
                    end if
                end repeat
                if not eqOpen then
                    click menu item "Equalizer" of menu "Window" of menu bar 1
                    delay 0.3
                end if
                tell window "Equalizer"
                    -- Enable EQ if not already on
                    if (value of checkbox "On") is 0 then
                        click checkbox "On"
                        delay 0.1
                    end if
                    -- Select the preset from the popup
                    click pop up button 1
                    delay 0.2
                    click menu item "\(escapedPreset)" of menu 1 of pop up button 1
                end tell
            end tell
        end tell
        """
        try executeScript(script)
    }

    // MARK: - Private Helpers

    @discardableResult
    private func executeScript(_ source: String) throws -> NSAppleEventDescriptor? {
        var error: NSDictionary?
        let script = NSAppleScript(source: source)
        let result = script?.executeAndReturnError(&error)
        if let error = error {
            let message = error[NSAppleScript.errorMessage] as? String ?? "Unknown AppleScript error"
            throw AuxError.appleScriptError(message: message)
        }
        return result
    }

    private func executeScriptWithResult(_ source: String) throws -> String {
        let result = try executeScript(source)
        return result?.stringValue ?? ""
    }

    private func emptyToNil(_ string: String) -> String? {
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        return trimmed.isEmpty || trimmed == "missing value" ? nil : trimmed
    }

    private func normalizeState(_ state: String) -> String {
        let trimmed = state.trimmingCharacters(in: .whitespaces).lowercased()
        switch trimmed {
        case "playing", "kpsplaying": return "playing"
        case "paused", "kpspaused": return "paused"
        case "stopped", "kpsstopped": return "stopped"
        case "fast forwarding", "kpsfast forwarding": return "fast_forwarding"
        case "rewinding", "kpsrewinding": return "rewinding"
        default: return trimmed
        }
    }

    private func tagKeyToAppleScriptProperty(_ key: String) -> String {
        switch key {
        case "name": return "name"
        case "artist": return "artist"
        case "album_artist": return "album artist"
        case "album": return "album"
        case "genre": return "genre"
        case "year": return "year"
        case "composer": return "composer"
        case "comments": return "comment"
        case "grouping": return "grouping"
        case "track_number": return "track number"
        case "track_count": return "track count"
        case "disc_number": return "disc number"
        case "disc_count": return "disc count"
        case "compilation": return "compilation"
        case "bpm": return "bpm"
        case "rating": return "rating"
        case "loved": return "loved"
        case "disliked": return "disliked"
        case "sort_name": return "sort name"
        case "sort_artist": return "sort artist"
        case "sort_album_artist": return "sort album artist"
        case "sort_album": return "sort album"
        case "sort_composer": return "sort composer"
        case "lyrics": return "lyrics"
        default: return key.replacingOccurrences(of: "_", with: " ")
        }
    }
}

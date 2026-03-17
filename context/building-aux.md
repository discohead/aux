# Building Aux: an Apple Music CLI and macOS app for coding agents

> **Version 1.1** — Updated March 15, 2026
>
> A macOS application and CLI that bridges Apple Music — MusicKit framework, REST API, and Music.app AppleScript — to structured JSON over stdio for coding agents.

---

## Executive summary

A macOS application called **Aux** that exposes 100% of Apple Music functionality for terminal-based coding agents is architecturally sound and fully feasible. Since MusicKit requires an `.app` bundle for its restricted entitlement anyway, Aux embraces this as a proper macOS citizen — a native app (Aux.app) handling authorization, preferences, and an "Install `aux` Command in PATH" flow modeled after VS Code, with a dual-mode binary that outputs structured JSON when invoked from a terminal.

Three platform constraints shape the internals into a **three-layer architecture**: MusicKit framework for catalog/library reads and authorization, the Apple Music REST API (via `MusicDataRequest`) for library writes that MusicKit marks as macOS-unavailable, and an AppleScript bridge to Music.app for playback control and a substantial set of capabilities that exist *nowhere else* — metadata writing, artwork manipulation, local file import, track deletion, AirPlay control, EQ management, and play statistics access.

The `aux` CLI covers **88 leaf commands** across 9 command groups with 18 stable output schemas.

---

## Table of contents

1. [Why MusicKit cannot run from a bare CLI binary](#1-why-musickit-cannot-run-from-a-bare-cli-binary)
2. [Aux.app: the macOS citizen with an `aux` CLI](#2-auxapp-the-macos-citizen-with-an-aux-cli)
3. [The three-layer architecture](#3-the-three-layer-architecture)
4. [Layer 1: MusicKit framework — catalog and library reads](#4-layer-1-musickit-framework)
5. [Layer 2: REST API via MusicDataRequest — library writes](#5-layer-2-rest-api-via-musicdatarequest)
6. [Layer 3: AppleScript bridge — playback and exclusive capabilities](#6-layer-3-applescript-bridge)
7. [Authentication, tokens, and entitlements](#7-authentication-tokens-and-entitlements)
8. [Swift CLI ecosystem: Package.swift and ArgumentParser](#8-swift-cli-ecosystem)
9. [DTO design and JSON output contract](#9-dto-design-and-json-output-contract)
10. [Complete subcommand tree](#10-complete-subcommand-tree)
11. [Prior art and references](#11-prior-art-and-references)

---

## 1. Why MusicKit cannot run from a bare CLI binary

The single most important finding for this project: Apple's MusicKit framework requires the `com.apple.application-identifier` restricted entitlement, which must be authorized by a provisioning profile embedded inside an `.app` bundle. Quinn "The Eskimo!" (Apple DTS) confirmed this definitively in Apple Developer Forums thread #711950. A bare Mach-O executable produces:

```
Error Domain=ICErrorDomain Code=-7009
"Failed to retrieve bundle identifier of the requesting application.
The requesting application is likely missing the
'com.apple.application-identifier' entitlement."
```

### Two proven workarounds

**Approach A — "Tool in App's Clothing" (recommended for distribution):** Wrap the CLI executable inside a minimal `.app` bundle structure with an `embedded.provisionprofile` and `Info.plist`. Users invoke it as `Aux.app/Contents/MacOS/aux` or via symlink. The system remembers TCC consent decisions for bundled apps, which is especially important on macOS 15 Sequoia where non-bundled CLI tools face recurring permission prompts.

```
Aux.app/
  Contents/
    Info.plist                    ← Bundle ID + NSAppleMusicUsageDescription
    MacOS/
      aux                         ← The actual Swift CLI binary
    PkgInfo
    _CodeSignature/
      CodeResources
    embedded.provisionprofile     ← Authorizes restricted entitlements
```

**Approach B — Linker-embedded Info.plist (simpler for development):** Embed an `Info.plist` directly into the Mach-O binary via SwiftPM linker flags (`-sectcreate __TEXT __info_plist`), then instruct users to manually add the binary in System Settings → Privacy & Security → Media & Apple Music. This is the approach used by Yatoro.

### Required Info.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>Aux</string>
    <key>CFBundleIdentifier</key><string>com.yourorg.aux</string>
    <key>NSAppleMusicUsageDescription</key>
    <string>Aux requires access to Apple Music for catalog search,
    library management, and playback control.</string>
</dict>
</plist>
```

---

## 2. Aux.app: the macOS citizen with an `aux` CLI

Since MusicKit requires an `.app` bundle regardless, Aux leans into it as a proper macOS application rather than treating the wrapper as a necessary evil. The architecture follows the VS Code model: a native app (Aux.app) that provides a GUI for setup and preferences, with a CLI binary (`aux`) that does the actual work.

### App responsibilities

Aux.app handles the concerns that benefit from a GUI context:

- **First-run authorization flow** — presenting the MusicKit consent dialog in a user-friendly context with explanation of what permissions are needed and why
- **"Install `aux` Command in PATH"** menu item — creates a symlink from `Aux.app/Contents/MacOS/aux` to `/usr/local/bin/aux` (or user-chosen location), identical to VS Code's "Install 'code' command"
- **Preferences UI** — token management, default output format, storefront selection, auto-update settings
- **Menu bar presence** (optional) — now-playing display, quick playback controls, connection status indicator
- **About / diagnostics** — version info, authorization status, subscription status, macOS compatibility check

### CLI responsibilities

The `aux` binary (the same Mach-O executable inside the `.app` bundle) handles everything else — all 88 commands, structured JSON output, agent consumption. When invoked from a terminal, it detects it's running headless and skips any GUI initialization.

### Bundle structure

```
Aux.app/
  Contents/
    Info.plist                    ← Bundle ID, usage descriptions, version
    MacOS/
      aux                         ← The Swift CLI binary (dual-mode)
    Resources/
      Assets.xcassets             ← App icon (3.5mm jack / waveform motif)
    PkgInfo
    _CodeSignature/
      CodeResources
    embedded.provisionprofile     ← Authorizes restricted entitlements
```

### Install flow

```
1. User downloads Aux.app, drags to /Applications
2. First launch → Aux.app triggers MusicAuthorization.request()
   → system consent dialog appears in GUI context
3. User clicks Aux menu → "Install `aux` Command in PATH"
   → Aux creates symlink: /usr/local/bin/aux → /Applications/Aux.app/Contents/MacOS/aux
   → May prompt for admin password if /usr/local/bin requires root
4. Agent (or user) runs: aux search songs "Autechre" --limit 5
   → binary detects headless mode, outputs JSON to stdout
```

### Dual-mode detection

```swift
@main
struct Aux: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "aux",
        abstract: "Apple Music CLI — structured JSON interface for agents",
        version: "1.1.0",
        subcommands: [
            Search.self, Catalog.self, Library.self, Playback.self,
            Auth.self, Recommendations.self, RecentlyPlayed.self,
            Ratings.self, API.self
        ]
    )
}

// In main.swift or App entry:
// If launched with CLI arguments → ArgumentParser handles it
// If launched as .app (double-click) → NSApplication / SwiftUI app launches
```

---

## 3. The three-layer architecture

Because MusicKit's playback and library-write APIs are unavailable on native macOS, and the Music.app AppleScript dictionary exposes an entire domain of capabilities that MusicKit doesn't cover at all, a single abstraction layer cannot cover everything. The correct design uses three complementary layers, selected per-command:

| Capability domain | Layer | Why this layer |
|---|---|---|
| Catalog search, browse, charts, suggestions | **MusicKit framework** | Type-safe, automatic tokens, Codable output |
| Library reads (songs, albums, playlists) | **MusicKit framework** | `MusicLibraryRequest` works on macOS 14.2+ |
| Authorization & subscription checks | **MusicKit framework** | `MusicAuthorization.request()` works on macOS |
| Recommendations, recently played | **MusicKit framework** | `MusicPersonalRecommendationsRequest`, etc. |
| Library writes (create playlist, add to library) | **REST API** via `MusicDataRequest` | `MusicLibrary.shared.add()` is `@available(macOS, unavailable)` |
| Ratings (get/set/delete) | **REST API** via `MusicDataRequest` | No framework-level rating API |
| Playback (play, pause, skip, seek, volume) | **AppleScript bridge** | `SystemMusicPlayer` is `@available(macOS, unavailable)` |
| **Metadata writing** (set tags on tracks) | **AppleScript bridge** | MusicKit is entirely read-only for metadata |
| **Artwork read/write** (raw binary data) | **AppleScript bridge** | MusicKit only provides CDN URLs |
| **Local file import** and audio conversion | **AppleScript bridge** | No MusicKit file import API exists |
| **Track deletion** from library | **AppleScript bridge** | Neither MusicKit nor REST API support deletion |
| **Play statistics** (read/write counts/dates) | **AppleScript bridge** | MusicKit exposes these as read-only |
| **Playlist manipulation** (delete, rename, reorder) | **AppleScript bridge** | REST API can only create and append |
| **AirPlay device control** | **AppleScript bridge** | MusicKit has no AirPlay API surface |
| **EQ preset management** | **AppleScript bridge** | MusicKit has no EQ API surface |
| **File-level metadata** (path, bit rate, codec) | **AppleScript bridge** | MusicKit doesn't expose file paths or codec info |

Apple engineer JoeKun confirmed on the Developer Forums (thread #698902) that bringing `ApplicationMusicPlayer` and `SystemMusicPlayer` to native macOS presents "significant engineering challenges." This has not changed through macOS 15 Sequoia. The AppleScript bridge to Music.app is the standard workaround — multiple production projects use it, including `kennethreitz/mcp-applemusic`, `mcthomas/Apple-Music-CLI-Player`, and `jayadamsmorgan/Yatoro`.

---

## 4. Layer 1: MusicKit framework

### Request types (all async/await)

MusicKit's request types form the core of the catalog and library interface. Every request returns a typed response via `try await request.response()`.

**`MusicCatalogSearchRequest`** (macOS 12.0+) searches the Apple Music catalog by term across multiple types. It supports `Song`, `Album`, `Artist`, `Playlist`, `Station`, `MusicVideo`, `Curator`, `RadioShow`, and `RecordLabel`. macOS 13+ added `includeTopResults` for relevancy-ranked cross-type results.

```swift
var request = MusicCatalogSearchRequest(term: "Autechre", types: [Song.self, Album.self])
request.limit = 25
request.offset = 0
let response = try await request.response()
// response.songs, response.albums, etc.
```

**`MusicCatalogResourceRequest<T>`** (macOS 12.0+) fetches specific items by ID, ISRC, or UPC. It supports eager-loading relationships via `.properties`:

```swift
var request = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: "1440935467")
request.properties = [.tracks, .artists]
let album = try await request.response().items.first!
```

**`MusicCatalogChartsRequest`** (macOS 13.0+) fetches charts with kinds `.mostPlayed`, `.dailyGlobalTop`, and `.cityTop`.

**`MusicCatalogSearchSuggestionsRequest`** (macOS 13.0+) provides autocomplete suggestions and top results.

**`MusicLibraryRequest<T>`** (macOS 14.0+, stable in 14.2+) queries the user's local library with filtering and sorting. **Critical note:** This type was NOT available on macOS 13 (Ventura) — it was introduced in macOS 14 Sonoma and had significant bugs (crashes with `MPModelGenre` errors, blank filter results) until macOS 14.2. Confirmed unavailable on macOS 13 via Apple Developer Forums thread #710322.

**`MusicLibrarySearchRequest`** (macOS 14.0+, stable 14.2+) searches the library by term across types.

**`MusicPersonalRecommendationsRequest`** (macOS 13.0+) fetches personalized recommendations.

**`MusicRecentlyPlayedRequest<T>`** (macOS 13.0+) fetches recently played tracks. Generic over `Song`, `MusicVideo`, and `Track`.

**`MusicRecentlyPlayedContainerRequest`** (macOS 13.0+) fetches recently played containers (albums, playlists, stations). Confirmed real via Apple engineer response in forum thread #696453.

**`MusicDataRequest`** (macOS 12.0+) is the escape hatch — it hits arbitrary Apple Music API endpoints with automatic token attachment, returning raw `Data` for custom decoding.

### Data model types

All MusicKit data model types conform to `MusicItem`, `Codable`, `Identifiable`, `Hashable`, and `Equatable`. The Codable conformance was confirmed in WWDC21 session 10294 — you can encode any MusicKit type directly to JSON.

Core types: `Song`, `Album`, `Artist`, `Playlist`, `MusicVideo`, `Station`, `Genre`, `Curator`, `RadioShow`, `RecordLabel`, and `Track` (a union wrapping `Song` or `MusicVideo`).

Supporting types: `MusicItemID` (strongly typed), `MusicItemCollection<T>` (paginated, with `hasNextBatch` and `nextBatch(limit:)`), `Artwork`, `PlayParameters`, `EditorialNotes`, `ContentRating`, `PreviewAsset`, `AudioVariant`.

Key properties added over iOS 16–18 / macOS 13–15: `audioVariants` (Spatial Audio, Lossless, Hi-Res Lossless), `isAppleDigitalMaster`, `lastPlayedDate`, `libraryAddedDate`, `playCount`.

### macOS version history

- **macOS 12 Monterey:** MusicKit framework launch. Catalog search, resource requests, `MusicDataRequest`, authorization, subscription, playback (iOS only).
- **macOS 13 Ventura:** Added charts, search suggestions, top results, recently played, recommendations, `Curator`, `RadioShow`, `AudioVariant`, `MusicTokenProvider`. Library request types were NOT available.
- **macOS 14 Sonoma:** `MusicLibraryRequest` and `MusicLibrarySearchRequest` brought to macOS (previously iOS-only). Critical bug fixes in 14.2.
- **macOS 15 Sequoia:** Tightened TCC permission handling. Favorites management APIs. Improved bundled app consent persistence.

---

## 5. Layer 2: REST API via MusicDataRequest

`MusicLibrary.shared.createPlaylist()` and `.add()` are `@available(macOS, unavailable)`. The REST API handles these operations through `MusicDataRequest`, which automatically attaches developer and user tokens:

```swift
// Create a playlist via REST API
let url = URL(string: "https://api.music.apple.com/v1/me/library/playlists")!
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")

struct Body: Encodable {
    struct Attributes: Encodable { let name: String; let description: String? }
    let attributes: Attributes
}
request.httpBody = try JSONEncoder().encode(
    Body(attributes: .init(name: "Focus", description: "Deep work playlist")))

let response = try await MusicDataRequest(urlRequest: request).response()
```

### Key REST API endpoints for library mutations

- **POST** `/v1/me/library/playlists` — create playlist
- **POST** `/v1/me/library/playlists/{id}/tracks` — add tracks to playlist
- **POST** `/v1/me/library` — add songs/albums to library (with `ids[songs]=` or `ids[albums]=` query params)
- **GET/PUT/DELETE** `/v1/me/ratings/{type}/{id}` — manage ratings

All `/me/` endpoints require a Music User Token, which MusicKit provides automatically after `MusicAuthorization.request()` succeeds.

---

## 6. Layer 3: AppleScript bridge

### Beyond playback: the AppleScript-exclusive capability domain

The initial design positioned the AppleScript bridge as a playback-only fallback. Research into the Music.app scripting dictionary (inherited from 20+ years of iTunes) revealed it is a **co-equal capability provider** that exposes entire functional domains inaccessible through MusicKit or the REST API.

The Music.app AppleScript dictionary was audited via Doug's AppleScripts reference (dougscripts.com, maintained since 2001), Apple Developer Forums threads #669239 and #694200, the mcp-applemusic MCP skill, and the Music.app `.sdef` scripting dictionary.

### 5.1 Metadata writing

MusicKit is entirely read-only for track metadata. The Apple Music REST API has no metadata write endpoints. AppleScript is the **only interface** that can SET properties on library tracks.

**33 writable properties** via AppleScript:

| Category | Writable properties |
|---|---|
| Core tags | name, artist, album artist, album, genre, year, composer, comments, grouping |
| Numbering | track number, track count, disc number, disc count |
| Flags & ratings | compilation, enabled, rating (0-100), loved, disliked |
| Audio properties | BPM, volume adjustment (-100 to +100), EQ preset, start time, finish time |
| Sort overrides | sort name, sort artist, sort album artist, sort album, sort composer |
| Text | lyrics |

```swift
// Example: set BPM and genre on a track via AppleScript
let script = """
tell application "Music"
    set t to first track whose database ID is \(trackID)
    set bpm of t to 128
    set genre of t to "Electronic"
end tell
"""
let appleScript = NSAppleScript(source: script)
var error: NSDictionary?
appleScript?.executeAndReturnError(&error)
```

**Caveat:** Only works on local/library tracks, not streaming-only Apple Music tracks. Streaming tracks may return incomplete properties on some macOS versions — this was broken in Big Sur, fixed in 11.3, but remains sporadic for certain properties (notably album name for non-library tracks).

### 5.2 Artwork manipulation

MusicKit provides CDN URLs for artwork (`Artwork.url(width:height:)`). AppleScript provides **raw binary data access** — you can read artwork data from tracks and write new artwork back. Tracks can have multiple artworks, accessed by index.

```swift
// Export artwork to file
let script = """
tell application "Music"
    set t to first track whose database ID is \(trackID)
    set artData to raw data of artwork 1 of t
end tell
"""

// Set artwork from file
let script = """
tell application "Music"
    set t to first track whose database ID is \(trackID)
    set data of artwork 1 of t to (read (POSIX file "/path/to/cover.jpg") as picture)
end tell
"""
```

### 5.3 Local file import and audio conversion

No MusicKit API can import local audio files. The AppleScript `add` command imports files into the library:

```swift
// Import audio file
let script = """
tell application "Music"
    add POSIX file "/path/to/track.wav"
end tell
"""
```

The `convert` command transcodes tracks using whatever encoder is configured in Music.app preferences (AAC, AIFF, ALAC, MP3, WAV) and returns a reference to the newly converted track. This is relevant for the `hdaw` workflow — an agent could render audio from `hdaw-engine`, import it into Music.app via `aux library import`, then convert it to AAC via `aux library convert`.

### 5.4 Track deletion

Neither MusicKit framework nor the REST API expose a delete operation for library items. AppleScript's `delete` command is the only way:

```swift
let script = """
tell application "Music"
    delete (first track whose database ID is \(trackID))
end tell
"""
```

### 5.5 File-level metadata

AppleScript exposes properties unavailable through MusicKit:

- **`location`** — full POSIX file path to the audio file
- **`bit rate`** — in kbps
- **`sample rate`** — in Hz (44100, 48000, 96000, etc.)
- **`size`** — file size in bytes
- **`kind`** — codec description ("MPEG audio file", "AAC audio file", "Apple Lossless audio file")
- **`modification date`** — file modification timestamp
- **`cloud status`** — iCloud Music Library status

The `reveal` command opens the track's file in Finder.

### 5.6 Play statistics (read AND write)

MusicKit exposes `playCount` and `lastPlayedDate` as read-only. AppleScript can both **read and write**:

- `played count` — number of times played
- `played date` — last played timestamp
- `skipped count` — number of times skipped
- `skipped date` — last skipped timestamp

This enables migrating play history, resetting counts, or backfilling data from external sources.

### 5.7 Advanced playlist manipulation

The REST API can create playlists and append tracks. AppleScript provides substantially more:

- **Delete playlists** (cannot delete smart playlists or Apple-generated playlists)
- **Rename playlists**
- **Remove specific tracks** from a playlist (without deleting from library)
- **Reorder tracks** within a playlist (`move track N to end of playlist`)
- **Copy tracks** between playlists (`duplicate track to end of user playlist`)

### 5.8 AirPlay device control

MusicKit has **no AirPlay API surface whatsoever**. AppleScript can:

- List available AirPlay devices with name, active state, and kind
- Activate or deactivate specific devices by name
- Query currently active output device(s)

### 5.9 EQ preset management

MusicKit has **no EQ API surface**. AppleScript can:

- List all available EQ presets
- Get the EQ preset assigned to a specific track
- Set a track's EQ preset

### 5.10 Library search with compound predicates

AppleScript's `whose` clause enables compound predicate filtering across any track property, including file-level metadata:

```applescript
-- Find all lossless Autechre tracks from after 2010
every track whose artist contains "Autechre" and year > 2010 and bit rate > 800
```

This is more flexible than `MusicLibraryRequest`'s filter chaining for queries involving properties MusicKit doesn't filter on (bit rate, sample rate, file size, etc.).

### 5.11 Playback control

The core playback AppleScript commands:

```swift
struct PlaybackBridge {
    static func play() throws {
        try runAppleScript("tell application \"Music\" to play")
    }
    static func pause() throws {
        try runAppleScript("tell application \"Music\" to pause")
    }
    static func nextTrack() throws {
        try runAppleScript("tell application \"Music\" to next track")
    }
    static func previousTrack() throws {
        try runAppleScript("tell application \"Music\" to previous track")
    }
    static func nowPlaying() throws -> NowPlayingDTO? {
        let script = """
        tell application "Music"
            if player state is playing or player state is paused then
                set t to name of current track
                set a to artist of current track
                set al to album of current track
                set d to duration of current track
                set p to player position
                set s to player state as string
                return t & "||" & a & "||" & al & "||" & ¬
                    (d as string) & "||" & (p as string) & "||" & s
            end if
        end tell
        """
        guard let result = try runAppleScript(script) else { return nil }
        let parts = result.components(separatedBy: "||")
        guard parts.count >= 6 else { return nil }
        return NowPlayingDTO(
            title: parts[0], artistName: parts[1], albumTitle: parts[2],
            durationSeconds: Double(parts[3]),
            positionSeconds: Double(parts[4]), state: parts[5]
        )
    }

    private static func runAppleScript(_ source: String) throws -> String? {
        let script = NSAppleScript(source: source)
        var error: NSDictionary?
        let result = script?.executeAndReturnError(&error)
        if let error { throw AppleScriptError(info: error) }
        return result?.stringValue
    }
}
```

For the `--watch` flag on `aux playback now-playing`, use a polling loop that emits NDJSON (one JSON object per line, on state changes).

### AppleScript caveats

- Streaming tracks (not added to library) may return incomplete properties on some macOS versions. Fixed in Big Sur 11.3 but sporadic issues persist.
- AppleScript is synchronous and single-threaded; bulk operations on large libraries should batch in chunks.
- The AppleScript command for adding streaming tracks to library (`duplicate current track to source "Library"`) is unreliable — confirmed by Apple engineer JoeKun in forum thread #694200.

---

## 7. Authentication, tokens, and entitlements

### MusicKit handles tokens automatically on Apple platforms

When the app has the MusicKit capability enabled and a valid App ID, the framework generates and manages both developer and user tokens internally. `MusicTokenProvider.shared` (macOS 13+) exposes them:

```swift
let devToken = try await MusicTokenProvider.shared.developerToken
let userToken = try await MusicTokenProvider.shared.userToken
```

**No manual JWT generation is needed for apps using the MusicKit framework.** This is a key advantage over the REST-only approach.

### Manual JWT generation (for REST API fallback or testing)

If bypassing MusicKit for some operations, you need a developer token JWT. Requirements:

- **Apple Developer Program membership** ($99/year)
- **MusicKit private key** (.p8 file, downloadable once from Certificates, Identifiers & Profiles)
- **10-character Key ID**
- **10-character Team ID**
- **Algorithm:** ES256
- **Maximum expiration:** 180 days

### User authorization flow on macOS

`MusicAuthorization.request()` triggers a system-level consent dialog — the OS presents it, not the app. This works in a CLI context (the dialog appears over the terminal). Authorization persists across launches in the TCC database for bundled apps.

```swift
let status = await MusicAuthorization.request()
guard status == .authorized else {
    throw MKError.notAuthorized
}
```

### Entitlements and provisioning

- App ID must have **MusicKit** enabled under App Services in the Apple Developer portal
- Entitlements file needs `com.apple.developer.musickit`
- A **provisioning profile** is required on macOS because `com.apple.application-identifier` is restricted
- Xcode automatic signing handles profile creation when you use an app target

---

## 8. Swift CLI ecosystem

### Package.swift

```swift
// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Aux",
    platforms: [.macOS(.v14)],
    products: [.executable(name: "aux", targets: ["aux"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git",
                 from: "1.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "aux",
            dependencies: [
                .product(name: "ArgumentParser",
                         package: "swift-argument-parser"),
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "-sectcreate",
                    "-Xlinker", "__TEXT",
                    "-Xlinker", "__info_plist",
                    "-Xlinker", "Sources/aux/Resources/Info.plist",
                ])
            ]
        ),
    ]
)
```

MusicKit is a system framework — no SPM dependency is needed. `import MusicKit` resolves from the macOS SDK.

### Command structure with AsyncParsableCommand

```swift
import ArgumentParser
import MusicKit
import Foundation

@main
struct Aux: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "aux",
        abstract: "Apple Music CLI — structured JSON interface for agents",
        version: "1.1.0",
        subcommands: [
            Search.self, Catalog.self, Library.self, Playback.self,
            Auth.self, Recommendations.self, RecentlyPlayed.self,
            Ratings.self, API.self
        ]
    )
}
```

See §2 for the dual-mode detection pattern (CLI vs GUI launch).

### stdout for data, stderr for diagnostics

Every successful command emits exactly one JSON object to stdout. Errors emit a `CLIErrorResponse` JSON to stdout and a human-readable message to stderr. This lets agents parse stdout reliably while humans can read stderr:

```swift
struct StderrStream: TextOutputStream {
    mutating func write(_ string: String) {
        FileHandle.standardError.write(Data(string.utf8))
    }
}
var stderr = StderrStream()

// In error handler:
let errJSON = CLIErrorResponse(error: .init(
    code: "not_authorized",
    message: "MusicKit authorization denied"))
try output.emit(errJSON)                // stdout: structured JSON
print("Error: not authorized", to: &stderr)  // stderr: human-readable
throw ExitCode(rawValue: 4)             // exit code: agent-parseable
```

### Exit codes

| Code | Name | Description |
|------|------|-------------|
| 0 | success | Command completed successfully |
| 1 | general_failure | Unspecified runtime error |
| 2 | usage_error | Invalid arguments or unknown subcommand |
| 3 | not_found | Requested resource not found |
| 4 | not_authorized | MusicKit authorization denied |
| 5 | network_error | Network request failed |
| 6 | service_error | Apple Music API returned an error |
| 7 | subscription_required | Operation requires active subscription |
| 8 | unavailable | Feature unavailable on current macOS version |

---

## 9. DTO design and JSON output contract

Although MusicKit types are natively Codable, their internal encoding structure can change between OS versions. Wrapper DTOs provide a stable contract:

```swift
struct SongDTO: Codable {
    let id: String
    let title: String
    let artistName: String
    let albumTitle: String?
    let durationSeconds: Double?
    let trackNumber: Int?
    let discNumber: Int?
    let genreNames: [String]
    let artworkURL: String?
    let url: String?
    let isrc: String?
    let releaseDate: String?
    let hasLyrics: Bool?
    let contentRating: String?
    let playCount: Int?
    let lastPlayedDate: String?
    let audioVariants: [String]?
    let isAppleDigitalMaster: Bool?

    init(from song: Song) {
        self.id = song.id.rawValue
        self.title = song.title
        self.artistName = song.artistName
        self.albumTitle = song.albumTitle
        self.durationSeconds = song.duration
        self.trackNumber = song.trackNumber
        self.discNumber = song.discNumber
        self.genreNames = song.genreNames
        self.artworkURL = song.artwork?
            .url(width: 600, height: 600)?.absoluteString
        self.url = song.url?.absoluteString
        self.isrc = song.isrc
        self.releaseDate = song.releaseDate?.formatted(.iso8601)
        self.hasLyrics = song.hasLyrics
        self.contentRating = song.contentRating?.rawValue
        self.playCount = song.playCount
        self.lastPlayedDate = song.lastPlayedDate?.formatted(.iso8601)
        self.audioVariants = song.audioVariants?.map(\.rawValue)
        self.isAppleDigitalMaster = song.isAppleDigitalMaster
    }
}
```

### The 18 output schemas

| Schema | Source | Purpose |
|--------|--------|---------|
| `SongDTO` | MusicKit `Song` | Catalog/library song representation |
| `AlbumDTO` | MusicKit `Album` | Catalog/library album with optional tracks |
| `ArtistDTO` | MusicKit `Artist` | Artist with optional top songs and albums |
| `PlaylistDTO` | MusicKit `Playlist` | Playlist with optional track listing |
| `MusicVideoDTO` | MusicKit `MusicVideo` | Music video representation |
| `StationDTO` | MusicKit `Station` | Radio station representation |
| `CuratorDTO` | MusicKit `Curator` | Curator with optional playlists |
| `RadioShowDTO` | MusicKit `RadioShow` | Radio show representation |
| `RecordLabelDTO` | MusicKit `RecordLabel` | Record label with optional releases |
| `GenreDTO` | MusicKit `Genre` | Genre with optional parent genre |
| `TrackDTO` | MusicKit `Track` | Union type wrapping Song or MusicVideo |
| `ChartDTO<T>` | MusicKit `MusicCatalogChart` | Chart result with typed items |
| `TopResultDTO` | MusicKit search | Cross-type top result from search |
| `StorefrontDTO` | MusicKit/REST | Apple Music storefront metadata |
| `NowPlayingDTO` | AppleScript | Current playback state from Music.app |
| **`TrackTagsDTO`** | AppleScript | **All 40 track properties (33 writable, 7 read-only)** |
| **`FileInfoDTO`** | AppleScript | **File path, bit rate, sample rate, size, codec** |
| **`PlayStatsDTO`** | AppleScript | **Play/skip counts and dates (read/write)** |

---

## 10. Complete subcommand tree

```
aux (88 leaf commands)
├── auth
│   ├── status              → authorization + subscription status
│   ├── request             → trigger system consent dialog
│   └── token               → retrieve developer/user tokens
│
├── search                  [MusicKit framework]
│   ├── songs <query>       [--limit] [--offset]
│   ├── albums <query>
│   ├── artists <query>
│   ├── playlists <query>
│   ├── music-videos <query>
│   ├── stations <query>
│   ├── curators <query>
│   ├── radio-shows <query>
│   ├── all <query>         [--types] [--top-results]
│   └── suggestions <term>
│
├── catalog                 [MusicKit framework]
│   ├── song <id>           [--include artists,albums]
│   ├── song-by-isrc <isrc>
│   ├── album <id>          [--include tracks] [--with-audio-variants]
│   ├── album-by-upc <upc>
│   ├── artist <id>         [--include albums,top-songs]
│   ├── playlist <id>       [--include tracks]
│   ├── music-video <id>
│   ├── station <id>
│   ├── curator <id>
│   ├── radio-show <id>
│   ├── record-label <id>
│   ├── genre <id>
│   ├── genres              → all top-level genres
│   ├── charts              [--kinds] [--types] [--genre] [--limit]
│   └── storefront [<id>]
│
├── library
│   │
│   │ ── MusicKit framework reads ──
│   ├── songs               [--limit] [--sort] [--filter-*] [--downloaded-only]
│   ├── albums              [--limit] [--sort] [--filter-*] [--downloaded-only]
│   ├── artists             [--limit] [--sort]
│   ├── playlists           [--limit] [--include-tracks]
│   ├── music-videos        [--limit]
│   ├── search <query>      [--types] [--limit]
│   │
│   │ ── REST API writes ──
│   ├── add <ids...>        --type songs|albums|playlists|music-videos
│   ├── create-playlist <n> [--description] [--tracks]
│   ├── add-to-playlist <playlist-id> <track-ids...>
│   │
│   │ ── AppleScript-exclusive operations ──
│   ├── import <paths...>   [--to-playlist]
│   ├── tag
│   │   ├── get <track-id>
│   │   ├── set <track-id>  --field key=value [--field ...]
│   │   └── batch-set <ids...> --field key=value [--field ...]
│   ├── lyrics
│   │   ├── get <track-id>
│   │   └── set <track-id>  [--text|--stdin|--file]
│   ├── artwork
│   │   ├── get <track-id>  [--output path] [--index N]
│   │   ├── set <track-id> <image-path>
│   │   └── count <track-id>
│   ├── file-info <track-id> → path, bit rate, sample rate, size, codec
│   ├── reveal <track-id>   → open file in Finder
│   ├── delete <ids...>     [--confirm]
│   ├── convert <ids...>    → transcode via Music.app encoder
│   ├── stats
│   │   ├── get <track-id>
│   │   ├── set <track-id>  [--played-count] [--played-date] [--skipped-*]
│   │   └── reset <ids...>
│   └── playlist-manage
│       ├── list-all        [--include-smart] [--include-folders]
│       ├── delete-playlist <name> [--confirm]
│       ├── rename-playlist <old> <new>
│       ├── remove-tracks <playlist> [--track-indices|--track-database-ids]
│       ├── reorder <playlist> --from N --to M|beginning|end
│       └── duplicate-tracks <source> <target> [--track-indices]
│
├── playback                [AppleScript bridge]
│   ├── play [<id>]         [--type] [--shuffle]
│   ├── pause
│   ├── stop
│   ├── next
│   ├── previous
│   ├── now-playing         [--watch] [--poll-interval]
│   ├── status              → state, position, volume, shuffle, repeat
│   ├── seek <position>
│   ├── volume [<level>]
│   ├── shuffle [on|off|toggle]
│   ├── repeat [off|one|all]
│   ├── fast-forward
│   ├── rewind
│   ├── airplay
│   │   ├── list
│   │   ├── select <device> [--active true|false]
│   │   └── current
│   └── eq
│       ├── list-presets
│       ├── get <track-id>
│       └── set <track-id> <preset>
│
├── recommendations         [--limit]
│
├── recently-played
│   ├── tracks              [--limit]
│   └── containers          [--limit]
│
├── ratings                 [REST API]
│   ├── get <id>            --type
│   ├── set <id> <value>    --type
│   └── delete <id>         --type
│
└── api                     [MusicDataRequest escape hatch]
    ├── get <path>          [--query key=value]
    ├── post <path>         [--body|--stdin]
    ├── put <path>          [--body|--stdin]
    └── delete <path>
```

---

## 11. Prior art and references

### Production projects

**Yatoro** (`jayadamsmorgan/Yatoro`, ~158 stars) — VIM-like TUI Apple Music player built entirely in Swift with MusicKit. Proves the linker-embedded Info.plist approach works and provides real-world patterns for MusicKit usage from a non-GUI process.

**MusadoraKit** (`rryam/MusadoraKit`) — The leading community companion library with convenience wrappers like `MCatalog.search()` and `MLibrary.playlists()`. Valuable reference for API patterns.

**mcp-applemusic** (`kennethreitz/mcp-applemusic`) — MCP server for controlling Apple Music via AppleScript. Directly analogous to the agent-consumption use case — demonstrates that the AppleScript bridge approach works reliably for agent tooling.

**Apple-Music-CLI-Player** (`mcthomas/Apple-Music-CLI-Player`) — Shell script wrapping osascript commands for playback, now-playing, and library browsing. Validates the AppleScript-to-CLI pattern.

### Apple documentation and sessions

- WWDC21: "Meet MusicKit for Swift" (session 10294) — framework introduction, Codable conformance
- WWDC22: "Explore more content with MusicKit" (session 110347) — charts, suggestions, library request, curators, audio variants
- WWDC22: "Meet Apple Music API and MusicKit" (session 10148) — REST API fundamentals, token management
- Apple Developer Forums threads #711950 (entitlement requirement), #710322 (MusicLibraryRequest unavailable macOS 13), #736717 (MusicLibraryRequest bugs macOS 14), #707436 / #698902 (ApplicationMusicPlayer macOS unavailability), #696453 (MusicRecentlyPlayedContainerRequest), #694200 (AppleScript add-to-library issues), #669239 (AppleScript streaming track properties)

### Doug's AppleScripts

Doug Adams' reference site (dougscripts.com, maintained 2001–2026) is the definitive community resource for the Music.app AppleScript dictionary. Critical references for track properties, playlist manipulation, artwork handling, and the full range of scriptable commands and classes.

---

## Conclusion

Aux is architecturally sound. The decision to embrace the `.app` bundle requirement — rather than fight it — transforms a platform constraint into an advantage: Aux.app handles first-run authorization in a proper GUI context, provides an "Install `aux` Command" flow modeled after VS Code, and can optionally surface a menu bar presence for quick playback control, while the `aux` binary does the real work as a lean stdio interface.

The three-layer design — MusicKit framework for reads, REST API for writes, AppleScript for everything else — is not merely a workaround for platform limitations but a genuinely comprehensive interface. The AppleScript layer in particular transforms Aux from a catalog/library browser into a full library management tool: an agent can import audio from the filesystem, tag it with metadata and artwork, organize it into playlists, control playback to AirPlay devices, analyze file-level properties, and manage play statistics — all through structured JSON over stdio.

The combination produces a tool where `aux search songs "Autechre" --limit 5` returns structured JSON in under a second, `aux library create-playlist "Focus"` creates a playlist via REST, `aux library tag set 12345 --field bpm=128 --field genre=Electronic` writes metadata via AppleScript, `aux library import /path/to/render.wav` brings in audio from the filesystem, and `aux playback airplay select "HomePod"` routes output to a specific speaker — all consumable by any coding agent that can invoke a shell command and parse JSON.

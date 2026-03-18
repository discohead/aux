# Aux

**Apple Music for coding agents.** A macOS app and CLI that exposes Apple Music as structured JSON over stdio — search, playback, library management, ratings, recommendations, and more.

Aux bridges three Apple APIs (MusicKit, Apple Music REST API, and Music.app AppleScript) into a single, consistent interface so AI agents and scripts can control Apple Music programmatically.

## Requirements

- macOS 14 (Sonoma) or later
- Xcode 15+
- An Apple Music subscription (for full functionality)

## Installation

### 1. Build and launch the app

```bash
git clone https://github.com/discohead/aux.git
cd aux
xcodebuild -scheme aux -destination 'platform=macOS' build
```

Or open `aux.xcodeproj` in Xcode and build the **aux** scheme (Cmd+B).

### 2. Authorize Apple Music

Launch **Aux.app**. On first run it will prompt for Apple Music access — click **Allow**. This is a one-time step; macOS remembers the authorization.

### 3. Install the CLI

From the Aux menu bar, select **Install aux Command in PATH**. This creates a symlink at `/usr/local/bin/aux` so you can run `aux` from any terminal.

## Quick Start

```bash
# Check authorization
aux auth status --pretty

# Search the catalog
aux search songs "Autechre" --limit 5 --pretty

# Play a track
aux playback play --track-id 12345

# What's playing?
aux playback now-playing --pretty

# Browse your library
aux library songs --artist "Arca" --limit 10 --pretty

# Create a playlist
aux library create-playlist "Late Night" --description "Ambient selections"

# Get personalized recommendations
aux recommendations list --pretty
```

Every command outputs structured JSON to stdout. Diagnostics go to stderr. Add `--pretty` for human-readable formatting.

## Commands

Aux provides **88 commands** across 9 groups:

| Group | Commands | Description |
|-------|----------|-------------|
| `auth` | `status`, `request`, `token` | Authorization and token management |
| `search` | `songs`, `albums`, `artists`, `playlists`, `music-videos`, `stations`, `curators`, `radio-shows`, `all`, `suggestions` | Catalog search and autocomplete |
| `catalog` | `song`, `album`, `artist`, `playlist`, `music-video`, `station`, `curator`, `radio-show`, `record-label`, `genre`, `all-genres`, `charts`, `storefront`, `song-by-isrc`, `album-by-upc` | Look up catalog items by ID, ISRC, or UPC |
| `library` | `songs`, `albums`, `artists`, `playlists`, `music-videos`, `search`, `add`, `delete`, `create-playlist`, `delete-playlist`, `rename-playlist`, `add-to-playlist`, `remove-from-playlist`, `reorder-tracks`, `find-duplicates`, `get-tags`, `set-tags`, `batch-set-tags`, `get-lyrics`, `set-lyrics`, `get-artwork`, `get-artwork-count`, `set-artwork`, `get-file-info`, `reveal`, `import`, `convert`, `get-play-stats`, `set-play-stats`, `reset-play-stats`, `list-playlists` | Full library management — browse, edit metadata, import files, manage playlists |
| `playback` | `play`, `pause`, `stop`, `next`, `previous`, `seek`, `fast-forward`, `rewind`, `now-playing`, `status`, `volume`, `shuffle`, `repeat`, `airplay-list`, `airplay-current`, `airplay-select`, `eq-list`, `eq-get`, `eq-set`, `play-next`, `add-to-queue` | Transport controls, queue management, AirPlay, EQ |
| `recently-played` | `tracks`, `containers` | Recently played history |
| `recommendations` | `list` | Personalized recommendations |
| `ratings` | `get`, `set`, `delete` | Rate and review library items |
| `api` | `get`, `post`, `put`, `delete` | Raw Apple Music API requests |

Run `aux <group> --help` for details on any command group, or `aux <group> <command> --help` for a specific command.

## Output Format

All commands return a consistent JSON envelope:

```json
{
  "data": {
    "id": "1613600186",
    "title": "LCC",
    "artist_name": "Autechre",
    "album_title": "Confield",
    "duration_seconds": 327.0,
    "genre_names": ["Electronic"],
    "artwork_url": "https://..."
  },
  "meta": {
    "limit": 25,
    "offset": 0,
    "total": 150,
    "has_next": true
  }
}
```

Errors return a structured error object with an exit code:

```json
{
  "error": {
    "code": "not_found",
    "message": "No song found with the given ID"
  }
}
```

| Exit Code | Meaning |
|-----------|---------|
| 0 | Success |
| 1 | General failure |
| 2 | Usage error |
| 3 | Not authorized |
| 4 | Not found |
| 5 | Network error |
| 6 | Service error |
| 7 | Subscription required |
| 8 | Unavailable |

## Global Options

Every command supports:

| Flag | Description |
|------|-------------|
| `--pretty` | Pretty-print JSON output |
| `--quiet` | Suppress non-JSON diagnostic output |

## Use Cases

### AI Agent Integration

Aux is designed as a tool for coding agents. Point your agent at the CLI and it can:

- Search and discover music via structured queries
- Build and manage playlists programmatically
- Control playback without leaving the terminal
- Read and write track metadata (tags, lyrics, artwork)
- Import local audio files into Apple Music
- Access play statistics and listening history

### Scripting and Automation

```bash
# Add all songs by an artist to a new playlist
ARTIST_SONGS=$(aux library songs --artist "Boards of Canada" | jq -r '.data[].id')
PLAYLIST=$(aux library create-playlist "BoC Collection" | jq -r '.data.id')
aux library add-to-playlist --playlist-id "$PLAYLIST" --track-ids "$ARTIST_SONGS"

# Export now-playing info for a status bar widget
aux playback now-playing | jq '{artist: .data.artist_name, title: .data.title}'

# Bulk-tag tracks
aux library batch-set-tags --input tags.json
```

### Raw API Access

For anything the CLI doesn't cover, use the `api` group to make direct Apple Music API calls:

```bash
aux api get "/v1/catalog/us/charts" --query "types=songs&limit=10" --pretty
```

## How It Works

No single Apple API covers all of Apple Music's functionality, so Aux combines three:

| Layer | What It Handles | Why |
|-------|----------------|-----|
| **MusicKit framework** | Search, catalog lookups, library reads, auth, recommendations | Type-safe Swift APIs with automatic token management |
| **Apple Music REST API** | Library writes — create playlists, add to library, ratings | `MusicLibrary.shared.add()` is unavailable on macOS |
| **AppleScript bridge** | Playback, metadata, artwork, file import, AirPlay, EQ, play stats | These capabilities only exist in Music.app |

The CLI and app share a single framework (**AuxKit**) so behavior is identical regardless of how you interact with Aux.

## License

MIT

## Links

- [Repository](https://github.com/discohead/aux)
- [Apple Music API Reference](https://developer.apple.com/documentation/applemusicapi)
- [MusicKit Documentation](https://developer.apple.com/musickit/)

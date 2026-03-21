# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Aux is a macOS application and CLI that bridges Apple Music (MusicKit framework, REST API, and Music.app AppleScript) to structured JSON over stdio for coding agents. It uses a three-layer architecture because no single Apple API covers all functionality.

## Build & Test Commands

Use `xcodebuildmcp` CLI instead of raw `xcodebuild`. Discover commands via `xcodebuildmcp --help` and `xcodebuildmcp tools`. Full skill reference:

@.claude/skills/xcodebuildmcp-cli/SKILL.md

```bash
# Discover available workflows and tools
xcodebuildmcp tools
xcodebuildmcp macos --help

# Build and test via xcodebuildmcp (preferred)
xcodebuildmcp macos build --scheme AuxKit --project-path aux.xcodeproj
xcodebuildmcp macos build --scheme auxCLI --project-path aux.xcodeproj
xcodebuildmcp macos build --scheme aux --project-path aux.xcodeproj
xcodebuildmcp macos test --scheme AuxKitTests --project-path aux.xcodeproj

# Fallback: raw xcodebuild (if xcodebuildmcp unavailable)
xcodebuild -scheme AuxKit -destination 'platform=macOS' build
xcodebuild -scheme AuxKit -destination 'platform=macOS' test
```

SPM dependency: `swift-argument-parser` >= 1.3.0 (resolved at 1.7.0).

## Architecture

### Targets and dependency flow

| Target | Type | Purpose |
|--------|------|---------|
| `AuxKit` | Framework | All business logic, DTOs, protocols, services, mocks |
| `aux` | macOS App | SwiftUI GUI, dual-mode detection, first-run MusicKit auth |
| `auxCLI` | CLI Tool | ArgumentParser commands (thin wrappers over AuxKit handlers) |
| `AuxKitTests` | Unit Tests | Tests AuxKit using Swift Testing (`@Test`, `#expect`) |

**Dependency flow:** `auxCLI` → `AuxKit` ← `AuxKitTests` | `aux` → `AuxKit`

### Three-layer service architecture

1. **MusicKit framework** — catalog search, library reads, auth, recommendations, history, favorites, summaries (type-safe, automatic tokens)
2. **REST API via `MusicDataRequest`** — library writes (create playlist, add to library, ratings) because `MusicLibrary.shared.add()` is `@available(macOS, unavailable)`
3. **AppleScript bridge to Music.app** — playback control, metadata writing, artwork, file import, track deletion, AirPlay, EQ, play stats (capabilities that exist nowhere else)

### Key patterns

- **Handler/Command split:** Every CLI command has a Handler (in AuxKit, testable with mocks) and a Command (in auxCLI, thin ArgumentParser wrapper). Tests target handlers, not commands.
- **Protocol-based DI:** Ten service protocols in `AuxKit/Protocols/` with mock implementations in `AuxKit/Mocks/`. `ServiceContainer` holds all services; `.mock()` returns test doubles.
- **DTOs over raw MusicKit types:** 19 DTO structs in `AuxKit/DTOs/` provide a stable JSON contract. All use explicit `CodingKeys` with snake_case naming and `static func fixture(...)` factories for tests.
- **Output envelope:** All CLI output goes through `OutputEnvelope<T>` (success with optional `PaginationMeta`) or `CLIErrorResponse`. JSON to stdout, diagnostics to stderr.
- **Shared JSON coding:** `JSONEncoder.aux` / `JSONDecoder.aux` in `AuxKit/Output/AuxJSONCoding.swift` (uses `.useDefaultKeys` since DTOs define explicit snake_case `CodingKeys`).
- **Exit codes:** `AuxExitCode` enum (0=success through 8=unavailable) in `AuxKit/Errors/`.

## TDD Methodology

This project follows strict red-green-refactor TDD. Implementation plan is in `context/aux-tdd-implementation-plan.md`.

- Phases 0–23 are substantially complete (~584 tests, 562 passing, 22 skipped).
- Tests use Swift Testing framework (`import Testing`, `@Test`, `#expect`), not XCTest.
- Every DTO has a `.fixture()` static factory for test data.
- Integration tests requiring MusicKit authorization use `.disabled("Requires MusicKit authorization")` trait.

## Platform Requirements

- macOS 14+ (Sonoma) — required for `MusicLibraryRequest`
- MusicKit requires an `.app` bundle with `com.apple.application-identifier` entitlement and MusicKit App Service enabled on the App ID (under "App Services" tab in Apple Developer portal, not "Capabilities")
- No special MusicKit entitlement key is needed in the entitlements file — automatic token generation works with just the App ID configuration
- Xcode automatic signing handles profile creation

## Build & Install Chain

The `aux` app is a dual-mode binary (GUI + CLI in one). `/usr/local/bin/aux` is a symlink to `/Applications/aux.app/Contents/MacOS/aux`.

```bash
# Build release
xcodebuildmcp macos build --scheme aux --project-path aux.xcodeproj --configuration Release

# Install — MUST rm first, then use ditto (not cp -R)
rm -rf /Applications/aux.app
ditto ~/Library/Developer/Xcode/DerivedData/aux-*/Build/Products/Release/aux.app /Applications/aux.app

# Symlink (one-time setup)
ln -sf /Applications/aux.app/Contents/MacOS/aux /usr/local/bin/aux
```

**Warning:** Never use `cp -R` to overwrite `.app` bundles. It fails silently with embedded framework symlinks, leaving stale binaries in place. Always `rm -rf` the old bundle first, then copy with `ditto`.

## MCP Server

Aux includes a native MCP server exposing all CLI functionality as MCP tools.

### Running

```bash
aux mcp serve
```

### Claude Desktop Configuration

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "aux": {
      "type": "stdio",
      "command": "/usr/local/bin/aux",
      "args": ["mcp", "serve"]
    }
  }
}
```

### Claude Code Configuration

Add to `.mcp.json`:

```json
{
  "mcpServers": {
    "aux": {
      "type": "stdio",
      "command": "/usr/local/bin/aux",
      "args": ["mcp", "serve"]
    }
  }
}
```

### Tool Groups

100+ tools across 12 groups: `aux_auth_*` (3), `aux_search_*` (10), `aux_catalog_*` (20), `aux_library_*` (31), `aux_playback_*` (21), `aux_recommendations_*` (1), `aux_recently_played_*` (2), `aux_ratings_*` (3), `aux_api_*` (4), `aux_history_*` (3), `aux_favorites_*` (1), `aux_summaries_*` (1)

## Key Reference

- Full design doc: `context/building-aux.md`
- API spec: `context/aux-api-spec.yaml`
- CLI has 100 leaf commands across 12 groups: auth, search, catalog, library, playback, recommendations, recently-played, ratings, api, history, favorites, summaries

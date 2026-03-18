# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Aux is a macOS application and CLI that bridges Apple Music (MusicKit framework, REST API, and Music.app AppleScript) to structured JSON over stdio for coding agents. It uses a three-layer architecture because no single Apple API covers all functionality.

## Build & Test Commands

Use `xcodebuildmcp` CLI instead of raw `xcodebuild`. Discover commands via `xcodebuildmcp --help` and `xcodebuildmcp tools`. See `.claude/skills/xcodebuildmcp-cli/SKILL.md` for the full skill.

```bash
# Discover available workflows and tools
xcodebuildmcp tools
xcodebuildmcp macos --help

# Build and test via xcodebuildmcp (preferred)
xcodebuildmcp macos build --scheme AuxKit --project aux.xcodeproj
xcodebuildmcp macos build --scheme auxCLI --project aux.xcodeproj
xcodebuildmcp macos build --scheme aux --project aux.xcodeproj
xcodebuildmcp macos test --scheme AuxKit --project aux.xcodeproj

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

1. **MusicKit framework** — catalog search, library reads, auth, recommendations (type-safe, automatic tokens)
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

- Phases 0–23 are substantially complete (~576 tests, 554 passing, 22 skipped).
- Tests use Swift Testing framework (`import Testing`, `@Test`, `#expect`), not XCTest.
- Every DTO has a `.fixture()` static factory for test data.
- Integration tests requiring MusicKit authorization use `.disabled("Requires MusicKit authorization")` trait.

## Platform Requirements

- macOS 14+ (Sonoma) — required for `MusicLibraryRequest`
- MusicKit requires an `.app` bundle with `com.apple.application-identifier` entitlement and provisioning profile
- Xcode automatic signing handles profile creation

## Key Reference

- Full design doc: `context/building-aux.md`
- API spec: `context/aux-api-spec.yaml`
- CLI has ~110 leaf commands across 12 groups: auth, search, catalog, library, playback, recommendations, recently-played, ratings, api, history, favorites, summaries

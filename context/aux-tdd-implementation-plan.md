# Aux TDD Implementation Plan

> Strict red-green-refactor. No production code without a failing test first.

**Status: ALL PHASES COMPLETE (444 tests passing, 22 skipped integration tests)** — Last updated 2026-03-16

---

## Architecture

**Multi-target Xcode project:**

| Target | Type | Purpose |
|--------|------|---------|
| `AuxKit` | Framework | All business logic, DTOs, protocols, services, mocks |
| `aux` | macOS App | SwiftUI GUI, dual-mode detection, first-run auth |
| `auxCLI` | CLI Tool | ArgumentParser commands (thin wrappers over AuxKit handlers) |
| `AuxKitTests` | Unit Tests | Tests AuxKit (Swift Testing framework) |

**Key pattern:** Every command has a **Handler** (in AuxKit, testable with mocks) and a **Command** (in auxCLI, thin ArgumentParser wrapper). Tests target handlers, not commands.

**Dependency flow:** `auxCLI` → `AuxKit` ← `AuxKitTests` | `aux` → `AuxKit`

---

## Phase 0: Project Restructuring (Config Only — No TDD) — DONE

No tests — pure project configuration.

1. Add SPM dependency: `swift-argument-parser` >= 1.3.0
2. Create `AuxKit` framework target with subdirectories:
   - `DTOs/`, `Errors/`, `Output/`, `Protocols/`, `Mocks/`, `Services/`, `Commands/`, `CLI/`, `App/`
3. Create `AuxKitTests` test bundle (host: AuxKit)
4. Create `auxCLI` command-line tool target linking AuxKit + ArgumentParser
5. Update `aux` app: remove SwiftData, link AuxKit
6. Delete `Item.swift`
7. Placeholder files so project compiles:
   - `AuxKit/AuxKit.swift` — `public enum Aux { public static let version = "1.1.0" }` (renamed from `AuxKit` to avoid module name collision with `BUILD_LIBRARY_FOR_DISTRIBUTION`)
   - `auxCLI/AuxCommand.swift` — `@main struct AuxCommand: AsyncParsableCommand` (replaces `main.swift`)
   - `AuxKitTests/AuxKitTests.swift` — one passing `@Test`
8. **Verify:** Build all targets, run tests → 1 passing test

**Notes:** AuxKitTests `TEST_HOST` and `BUNDLE_LOADER` cleared so tests run standalone against AuxKit.framework (not hosted in aux.app).

**Files:** `AuxKit/AuxKit.swift`, `auxCLI/AuxCommand.swift`, `AuxKitTests/AuxKitTests.swift`, modified `auxApp.swift`, `ContentView.swift`, deleted `Item.swift`

---

## Phase 1: Output Infrastructure — DONE (10 tests)

### RED — Tests first
`AuxKitTests/Output/OutputEnvelopeTests.swift`:
- `successEnvelopeEncodesDataField` — envelope has `data`, no `error`
- `successEnvelopeEncodesMetaWhenPresent` — `meta.limit`, `meta.total`, `meta.has_next`
- `successEnvelopeOmitsMetaWhenNil` — no `meta` key in JSON
- `successEnvelopeUsesSnakeCaseKeys` — `has_next` not `hasNext`
- `errorResponseEncodesErrorObject` — `error.code`, `error.message`
- `errorResponseEncodesOptionalDetails` — `error.details` present
- `errorResponseOmitsDetailsWhenNil` — no `details` key

`AuxKitTests/Output/OutputWriterTests.swift`:
- `writerEmitsCompactJSONByDefault` — no indentation
- `writerEmitsPrettyJSONWhenRequested` — has indentation
- `stderrHelperConformsToTextOutputStream` — compiles and writes

### GREEN — Implementation
- `AuxKit/Output/OutputEnvelope.swift` — generic `OutputEnvelope<T: Encodable>` with optional `PaginationMeta`
- `AuxKit/Output/CLIErrorResponse.swift` — `CLIErrorResponse` with `ErrorBody` (code, message, details)
- `AuxKit/Output/OutputWriter.swift` — `OutputWriter` protocol, `JSONOutputWriter`, `StderrOutputStream`

### REFACTOR
- Add `AnyCodable` type-erased wrapper for details dict
- Consolidate encoder creation

**Depends on:** Phase 0

---

## Phase 2: Exit Codes — DONE (11 tests)

### RED
`AuxKitTests/Errors/ExitCodeTests.swift`:
- `successIsZero` through `unavailableIsEight` — 9 raw value tests
- `allCasesHaveUniqueValues` — no collisions
- `nameReturnsSnakeCaseString` — e.g. `.notFound` → `"not_found"`

### GREEN
`AuxKit/Errors/AuxExitCode.swift` — `enum AuxExitCode: Int32, CaseIterable, Sendable` with `name` computed property

**Depends on:** Phase 0

---

## Phase 3: Error Types — DONE (11 tests)

### RED
`AuxKitTests/Errors/AuxErrorTests.swift`:
- Each case maps to correct `exitCode` and `code` string (9 tests)
- `toCLIErrorResponseProducesValidJSON` — code and message propagate
- `appleScriptErrorHasCorrectExitCode` — maps to `.serviceError`

### GREEN
`AuxKit/Errors/AuxError.swift` — `enum AuxError: Error, Sendable` with cases: `notAuthorized`, `notFound`, `networkError`, `serviceError`, `subscriptionRequired`, `unavailable`, `generalFailure`, `appleScriptError`, `usageError`. Properties: `exitCode`, `code`, `message`, `toCLIErrorResponse()`

**Depends on:** Phase 1 (CLIErrorResponse), Phase 2 (AuxExitCode)

---

## Phase 4: DTO Types (18 Schemas) — DONE (47 tests)

### RED — Batch 1: Simple DTOs
Tests for `GenreDTO`, `StorefrontDTO`, `StationDTO`, `RadioShowDTO`, `CuratorDTO`, `RecordLabelDTO`:
- `roundTripsViaJSON` — encode → decode → equality
- `usesSnakeCaseKeys` — verify key names in JSON string

### RED — Batch 2: Core DTOs
Tests for `SongDTO`, `AlbumDTO`, `ArtistDTO`, `PlaylistDTO`, `MusicVideoDTO`:
- `roundTripsViaJSON` — full encode/decode cycle
- `usesSnakeCaseJSONKeys` — all multi-word keys snake_cased
- `nullableFieldsOmittedWhenNil` — compact JSON
- `tracksFieldContainsSongDTOs` (Album) — nested array encodes

### RED — Batch 3: Composite + AppleScript DTOs
Tests for `TrackDTO`, `ChartDTO`, `TopResultDTO`, `NowPlayingDTO`, `TrackTagsDTO`, `FileInfoDTO`, `PlayStatsDTO`:
- `songVariantEncodesTypeAsSong` (Track) — discriminator field
- `allWritableFieldsArePresent` (TrackTags) — 33+ fields exist
- Standard roundtrip tests

### GREEN
18 DTO files in `AuxKit/DTOs/` + `AuxKit/Output/AuxJSONCoding.swift` (shared `JSONEncoder.aux` / `JSONDecoder.aux` with snake_case strategy)

Each DTO: `public struct XxxDTO: Codable, Equatable, Sendable` with explicit `CodingKeys`, `init(...)`, and `static func fixture(...)` factory

### REFACTOR
- Verify every DTO matches spec field list exactly
- ~50 tests total

**Depends on:** Phase 0

---

## Phase 5: Service Protocols — DONE (7 tests)

### RED
`AuxKitTests/Protocols/ServiceProtocolTests.swift`:
- For each protocol, define a local stub conformance inside the test — verifies the protocol compiles with all required methods
- 7 tests (one per protocol): `MusicCatalogService`, `MusicLibraryService`, `RESTAPIService`, `AppleScriptBridgeProtocol`, `AuthService`, `RecommendationsService`, `RecentlyPlayedService`

### GREEN
7 protocol files in `AuxKit/Protocols/` + supporting result types in `AuxKit/DTOs/Results/`:
- `SearchAllResult`, `SuggestionsResult`, `ChartsResult`, `LibrarySearchResult`, `CreatePlaylistResult`, `RatingResult`, `PlayerStatusResult`, `AirPlayDeviceResult`, `ImportResult`, `ArtworkResult`, `ConvertResult`, `PlaylistInfoResult`, `AuthStatusResult`, `TokenResult`, `RecommendationsResult`, `RecentlyPlayedContainersResult`, `LibrarySongFilters`, `LibraryAlbumFilters`

**Depends on:** Phase 4 (DTOs)

---

## Phase 6: Mock Implementations — DONE (38 tests)

### RED
`AuxKitTests/Mocks/MockServiceTests.swift`:
- `returnsConfiguredSongs` — mock returns preset results
- `recordsMethodCalls` — mock tracks which methods were called with what args
- `throwsConfiguredError` — mock throws preset error
- `returnsConfiguredNowPlaying` — AppleScript mock returns NowPlayingDTO
- `pauseRecordsCall` — verifies side-effect tracking

### GREEN
7 mock files in `AuxKit/Mocks/` — each is a `public final class` conforming to its protocol with:
- `Result<T, Error>` properties for configuring return values
- `Bool` flags and `[String]` arrays for recording calls

### REFACTOR
- Add `.fixture()` convenience on DTOs if not done in Phase 4
- Add `reset()` methods on mocks

**Depends on:** Phase 5

---

## Phase 7: Service Container (DI) — DONE (2 tests)

### RED
`AuxKitTests/ServiceContainerTests.swift`:
- `defaultContainerProvidesMocks` — `.mock()` returns all mock services
- `containerAcceptsCustomServices` — custom service injected and retrievable

### GREEN
`AuxKit/ServiceContainer.swift` — holds `any MusicCatalogService`, `any MusicLibraryService`, etc. with `static func mock()` and `static func live()`

**Depends on:** Phase 6

---

## Phase 8: Global Options — DONE (5 tests)

### RED
`AuxKitTests/CLI/GlobalOptionsTests.swift`:
- `defaultsAreFalse` — pretty/raw/quiet all false
- `makeOutputWriterRespectsPrettyFlag` — pretty=true → pretty output
- `stderrPrintSuppressedWhenQuiet` — quiet=true → no output

### GREEN
`AuxKit/CLI/GlobalOptions.swift` — plain struct with `makeOutputWriter()` and `stderrPrint(_:)`

**Depends on:** Phase 1

---

## Phase 9: Root Command Structure — DONE (3 tests)

### RED
`AuxKitTests/CLI/RootCommandTests.swift`:
- `commandNameIsAux`
- `versionIs1_1_0`
- `hasNineSubcommandGroups` — auth, search, catalog, library, playback, recommendations, recently-played, ratings, api

### GREEN
- `AuxKit/CLI/AuxCommandConfiguration.swift` — constants and subcommand name list
- `auxCLI/AuxCommand.swift` — `@main struct AuxCommand: AsyncParsableCommand` referencing config

**Depends on:** Phase 8

---

## Phases 10-20: Command Groups — ALL DONE (289 tests)

**Every command follows the same TDD cycle:**

1. **RED:** Write handler test in `AuxKitTests/Commands/{Group}/{Name}HandlerTests.swift`
   - Test happy path with mock returning expected data
   - Test error path with mock throwing `AuxError`
   - Test edge cases (empty results, nil optionals, boundary values)
2. **GREEN:** Implement handler in `AuxKit/Commands/{Group}/{Name}Handler.swift`
   - Takes `ServiceContainer`, `GlobalOptions`, command-specific params, optional `writer: (any OutputWriterProtocol)?`
   - Calls service, wraps result in `OutputEnvelope`, writes via `JSONOutputWriter`
3. **GREEN:** Wire CLI command in `auxCLI/Commands/{Group}/{Name}Command.swift`
   - ArgumentParser `@Argument`/`@Option`/`@Flag` declarations
   - `run()` creates `GlobalOptions`, `ServiceContainer.mock()` (placeholder), calls handler
4. **REFACTOR:** Extract common patterns (shared error handling, pagination helpers)

**Implementation approach:** Phases 10-20 were executed in parallel via 7 independent agents, each writing exclusively to its own group directories. Group parent commands wired up at checkpoint.

### Phase 10: Auth (3 commands) — DONE (9 tests)
`AuthStatusHandler`, `AuthRequestHandler`, `AuthTokenHandler`
- 3 handlers in `AuxKit/Commands/Auth/`
- 3 commands in `auxCLI/Commands/Auth/`
- 3 test files in `AuxKitTests/Commands/Auth/` (3 tests each)

### Phase 11: Search (10 commands) — DONE (30 tests)
`SearchSongsHandler`, `SearchAlbumsHandler`, `SearchArtistsHandler`, `SearchPlaylistsHandler`, `SearchMusicVideosHandler`, `SearchStationsHandler`, `SearchCuratorsHandler`, `SearchRadioShowsHandler`, `SearchAllHandler`, `SearchSuggestionsHandler`
- 10 handlers + 10 commands + 10 test files (3 tests each)

### Phase 12: Catalog (15 commands) — DONE (45 tests)
`CatalogSongHandler`, `CatalogSongByISRCHandler`, `CatalogAlbumHandler`, `CatalogAlbumByUPCHandler`, `CatalogArtistHandler`, `CatalogPlaylistHandler`, `CatalogMusicVideoHandler`, `CatalogStationHandler`, `CatalogCuratorHandler`, `CatalogRadioShowHandler`, `CatalogRecordLabelHandler`, `CatalogGenreHandler`, `CatalogAllGenresHandler`, `CatalogChartsHandler`, `CatalogStorefrontHandler`
- 15 handlers + 15 commands + 15 test files (3 tests each)

### Phases 13-15: Library (31 commands) — DONE (90 tests)

**Library Reads (6):** `LibrarySongsHandler`, `LibraryAlbumsHandler`, `LibraryArtistsHandler`, `LibraryPlaylistsHandler`, `LibraryMusicVideosHandler`, `LibrarySearchHandler`

**Library REST Writes (3):** `LibraryAddHandler`, `LibraryCreatePlaylistHandler`, `LibraryAddToPlaylistHandler`

**Library AppleScript (22):** `LibraryGetTagsHandler`, `LibrarySetTagsHandler`, `LibraryBatchSetTagsHandler`, `LibraryGetLyricsHandler`, `LibrarySetLyricsHandler`, `LibraryGetArtworkHandler`, `LibrarySetArtworkHandler`, `LibraryGetArtworkCountHandler`, `LibraryGetFileInfoHandler`, `LibraryRevealHandler`, `LibraryDeleteHandler`, `LibraryConvertHandler`, `LibraryImportHandler`, `LibraryGetPlayStatsHandler`, `LibrarySetPlayStatsHandler`, `LibraryResetPlayStatsHandler`, `LibraryListPlaylistsHandler`, `LibraryDeletePlaylistHandler`, `LibraryRenamePlaylistHandler`, `LibraryRemoveFromPlaylistHandler`, `LibraryReorderTracksHandler`, `LibraryFindDuplicatesHandler`

- 31 handlers + 31 commands + 6 consolidated test files
- Shared type: `LibraryActionResult` in `AuxKit/Commands/Library/LibraryActionResult.swift`

### Phase 16: Playback (19 commands) — DONE (57+ tests)

**Transport:** `PlayHandler`, `PauseHandler`, `StopHandler`, `NextHandler`, `PreviousHandler`
**Status:** `NowPlayingHandler`, `PlayerStatusHandler`
**Controls:** `SeekHandler`, `VolumeHandler`, `ShuffleHandler`, `RepeatHandler`, `FastForwardHandler`, `RewindHandler`
**AirPlay:** `AirPlayListHandler`, `AirPlaySelectHandler`, `AirPlayCurrentHandler`
**EQ:** `EQListPresetsHandler`, `EQGetHandler`, `EQSetHandler`

- 19 handlers + 19 commands + 19 test files
- Shared types: `SuccessResult`, `AirPlayCurrentResult`, `EQPresetsResult`, `EQCurrentResult` in `AuxKit/Commands/Playback/`

### Phase 17: Recommendations (1 command) — DONE (4 tests)
`RecommendationsHandler` — calls `services.recommendations.getRecommendations(limit:)`
- 1 handler + 1 command (`RecommendationsListCommand`) + 1 test file

### Phase 18: Recently Played (2 commands) — DONE (8 tests)
`RecentlyPlayedTracksHandler`, `RecentlyPlayedContainersHandler`
- 2 handlers + 2 commands + 2 test files (4 tests each)

### Phase 19: Ratings (3 commands) — DONE (9 tests)
`RatingsGetHandler`, `RatingsSetHandler`, `RatingsDeleteHandler`
- Uses `RESTAPIService` with paths like `/v1/me/ratings/{type}/{id}`
- 3 handlers + 3 commands + 1 consolidated test file

### Phase 20: API (4 commands) — DONE (12 tests)
`APIGetHandler`, `APIPostHandler`, `APIPutHandler`, `APIDeleteHandler`
- Raw REST API wrappers returning `RawAPIResponse` (statusCode + body)
- 4 handlers + 4 commands + 1 consolidated test file
- Shared type: `RawAPIResponse` in `AuxKit/Commands/API/RawAPIResponse.swift`

---

## Phase 21: Live Service Implementations — DONE (17 helper tests + 22 disabled integration tests)

### Helper classes (unit-testable)
- `AuxKit/Services/Helpers/RESTURLBuilder.swift` — URL construction for Apple Music API
- `AuxKit/Services/Helpers/AppleScriptBuilder.swift` — AppleScript command generation
- `AuxKit/Services/Helpers/AppleScriptRunner.swift` — NSAppleScript execution wrapper
- `AuxKit/Services/Helpers/MusicKitToDTOMapper.swift` — Duration, date, artwork URL formatting

### Helper tests
- `AuxKitTests/Services/RESTURLBuilderTests.swift` — 5 tests
- `AuxKitTests/Services/AppleScriptBuilderTests.swift` — 6 tests
- `AuxKitTests/Services/MusicKitToDTOMapperTests.swift` — 6 tests

### Live service implementations
- `AuxKit/Services/LiveAuthService.swift` — MusicAuthorization wrapper
- `AuxKit/Services/LiveMusicCatalogService.swift` — Full MusicKit catalog (search + get by ID + charts + storefronts)
- `AuxKit/Services/LiveMusicLibraryService.swift` — `@available(macOS 14.0, *)` MusicLibraryRequest wrapper
- `AuxKit/Services/LiveRESTAPIService.swift` — MusicDataRequest wrapper (auto token injection)
- `AuxKit/Services/LiveAppleScriptBridge.swift` — NSAppleScript for all 31 protocol methods
- `AuxKit/Services/LiveRecommendationsService.swift` — MusicPersonalRecommendationsRequest
- `AuxKit/Services/LiveRecentlyPlayedService.swift` — MusicRecentlyPlayedRequest + REST fallback

### Integration tests (disabled for CI)
- `AuxKitTests/Services/LiveServiceIntegrationTests.swift` — 22 tests, all `.disabled("Requires MusicKit authorization")` or `.disabled("Requires Music.app running")`

### Wire-up
- `ServiceContainer.live()` static method added (`@available(macOS 14.0, *)`)

---

## Phase 22: SwiftUI App — DONE (5 tests)

### Tests
- `AuxKitTests/App/LaunchModeDetectorTests.swift` — 2 tests (detect returns valid mode, enum cases distinct)
- `AuxKitTests/App/CLIInstallerTests.swift` — 3 tests (default path, nonexistent check, install/uninstall roundtrip)

### Implementation
- `AuxKit/App/LaunchModeDetector.swift` — `LaunchMode` enum (.gui/.cli), detection via executable name, TTY check, argument sniffing
- `AuxKit/App/CLIInstaller.swift` — Symlink management (install/uninstall/isInstalled at `/usr/local/bin/aux`)
- `aux/auxApp.swift` — Updated with Settings scene
- `aux/ContentView.swift` — MusicKit auth status display, authorization button, version label
- `aux/Views/PreferencesView.swift` — CLI install/uninstall UI with status indicator

---

## Phase 23: Integration & E2E Validation — DONE (20 tests)

### CommandPipelineTests (14 tests)
- Handler → envelope → JSON roundtrips: auth status, search songs, catalog song, playback play, recommendations
- Error → CLIErrorResponse → exit code pipeline: not found, network error, not authorized
- All error codes have unique values
- Fixture validity: SongDTO, AlbumDTO, NowPlayingDTO produce valid JSON envelopes
- Cross-group integration: search → catalog lookup using parsed IDs
- Pretty-print output verification

### ErrorPipelineTests (6 tests)
- Handler error → CLIErrorResponse JSON serialization
- Auth error exit code verification (rawValue 3)
- AppleScript error maps to serviceError exit code
- Error response JSON structure
- Network error with absent details
- All 9 AuxError variants produce valid JSON

**Depends on:** All previous phases

---

## Phase Dependency Graph

```
Phase 0 (Project Setup)
├── Phase 1 (Output)
│   ├── Phase 2 (Exit Codes)
│   │   └── Phase 3 (Errors)
│   └── Phase 8 (Global Options)
├── Phase 4 (DTOs)
│   └── Phase 5 (Protocols)
│       └── Phase 6 (Mocks)
│           └── Phase 7 (Container)
│               └── Phase 9 (Root Command)
│                   └── Phases 10-20 (Commands — parallelizable)
│                       ├── Phase 21 (Live Services)
│                       └── Phase 22 (SwiftUI App)
│                           └── Phase 23 (Integration)
```

---

## Test Count Summary

| Phase | Estimated | Actual | Status |
|-------|----------:|-------:|--------|
| 0 Setup | 1 | 1 | DONE |
| 1 Output | 10 | 10 | DONE |
| 2 Exit Codes | 11 | 11 | DONE |
| 3 Errors | 10 | 11 | DONE |
| 4 DTOs | ~50 | 47 | DONE |
| 5 Protocols | 7 | 7 | DONE |
| 6 Mocks | 15 | 38 | DONE |
| 7 Container | 2 | 2 | DONE |
| 8 Global Options | 3 | 5 | DONE |
| 9 Root Command | 3 | 3 | DONE |
| **Subtotal (0-9)** | **~112** | **135** | **DONE** |
| 10 Auth | ~9 | 9 | DONE |
| 11 Search | ~30 | 30 | DONE |
| 12 Catalog | ~45 | 45 | DONE |
| 13-15 Library | ~87 | 90 | DONE |
| 16 Playback | ~60 | 57+ | DONE |
| 17 Recommendations | ~3 | 4 | DONE |
| 18 Recently Played | ~6 | 8 | DONE |
| 19 Ratings | ~9 | 9 | DONE |
| 20 API | ~12 | 12 | DONE |
| **Subtotal (10-20)** | **~261** | **~264** | **DONE** |
| 21 Live Services | 15 | 17 + 22 disabled | DONE |
| 22 App | 5 | 5 | DONE |
| 23 Integration | 10 | 20 | DONE |
| **Total** | **~400** | **466 (444 pass + 22 skip)** | **DONE** |

> Note: 22 skipped tests are disabled integration tests requiring MusicKit authorization or Music.app running. All 444 enabled tests pass.

---

## Verification

After each phase:
1. `BuildProject` — all targets compile
2. `RunAllTests` — all tests pass, zero failures
3. New tests written in RED must fail before implementation
4. After GREEN, all tests pass including previous phases
5. After REFACTOR, all tests still pass

Final validation (2026-03-16):
- ✅ Build succeeds for `AuxKit`, `aux`, `auxCLI`
- ✅ `RunAllTests` → 466 total (444 passed, 0 failed, 22 skipped)
- ✅ `auxCLI` binary runs: `aux --version` → `1.1.0`
- ✅ `auxCLI` binary runs: `aux --help` → shows 9 subcommand groups (auth, search, catalog, library, playback, recommendations, recently-played, ratings, api)
- ✅ 88 leaf commands wired across 9 groups
- ✅ 7 live service implementations with `ServiceContainer.live()`
- ✅ SwiftUI app with MusicKit auth UI and CLI installer preferences
- ✅ 22 disabled integration tests can be manually enabled to test against real MusicKit/Music.app

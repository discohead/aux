# AuxKit CLI

[Swift Argument Parser](https://github.com/apple/swift-argument-parser) command layer for the `aux` CLI. Each command is a thin wrapper that delegates to an AuxKit handler — all business logic lives in the handlers, keeping commands focused on argument parsing and error handling.

## Architecture

```
AuxCommand (root)
├── AuxCommandConfiguration    # Shared constants (name, version, abstract)
├── GlobalOptions              # --pretty, --raw, --quiet flags + output writer factory
├── CommandErrorHandler        # Error → CLIErrorResponse JSON on stderr + exit code
├── FieldParser                # Parses "key=value,key=value" strings for metadata fields
└── Commands/                  # 114 commands across 13 groups
    ├── Auth/          (3)     # status, request, token
    ├── Search/       (10)     # songs, albums, artists, playlists, stations, etc.
    ├── Catalog/      (20)     # get, charts, genres, top charts, etc.
    ├── Library/      (31)     # list, add, create playlist, import, delete, etc.
    ├── Playback/     (21)     # play, pause, next, queue, AirPlay, EQ, shuffle, etc.
    ├── Recommendations/ (1)   # personal recommendations
    ├── RecentlyPlayed/  (2)   # recently played tracks/stations
    ├── Ratings/      (3)      # get, set, delete
    ├── API/          (4)      # raw MusicDataRequest access
    ├── History/      (3)      # heavy rotation, history
    ├── Favorites/    (1)      # favorites management
    ├── Summaries/    (1)      # listening summaries
    └── MCP/          (1)      # mcp serve (starts MCP server)
```

## Command Pattern

Every command follows the same structure:

```
┌──────────────────┐       ┌──────────────────┐
│  FooBarCommand   │──────▶│  FooBarHandler   │
│  (CLI/Commands/) │       │  (Handlers/)      │
│                  │       │                   │
│  • @Argument     │       │  • ServiceContainer│
│  • @Option       │       │  • Business logic  │
│  • @Flag         │       │  • OutputWriter    │
│  • GlobalOptions │       │  • Testable w/mocks│
└──────────────────┘       └──────────────────┘
```

1. **Command** (`AsyncParsableCommand`) — defines arguments/flags, creates `GlobalOptions`, calls the handler, catches errors via `CommandErrorHandler`.
2. **Handler** (in `AuxKit/Handlers/`) — receives `ServiceContainer` + options, runs business logic, writes JSON via `OutputWriterProtocol`.

Example (`AuthStatusCommand`):

```swift
public struct AuthStatusCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "status",
        abstract: "Check Apple Music authorization status"
    )

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await AuthStatusHandler.handle(services: services, options: options)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
}
```

## Key Types

| Type | Role |
|------|------|
| `AuxCommand` | Root command — registers all 13 subcommand groups |
| `AuxCommandConfiguration` | Shared constants: command name, version, abstract |
| `GlobalOptions` | Output formatting flags (`--pretty`, `--raw`, `--quiet`) and `JSONOutputWriter` factory |
| `CommandErrorHandler` | Maps errors to `CLIErrorResponse` + `AuxExitCode`, writes JSON to stderr, exits |
| `FieldParser` | Parses comma-separated `key=value` pairs for metadata update commands |

## Output Contract

- **Success** → JSON to stdout via `OutputEnvelope<T>` (with optional `PaginationMeta`)
- **Error** → JSON to stderr via `CLIErrorResponse`, process exits with `AuxExitCode`
- **Diagnostics** → stderr (suppressed by `--quiet`)

## Adding a New Command

1. Create the handler in `AuxKit/Handlers/` (testable, uses `ServiceContainer`).
2. Create `FooBarCommand.swift` in the appropriate `Commands/<Group>/` directory.
3. Add it as a subcommand in the group's parent command configuration.
4. Write tests against the handler using `ServiceContainer.mock()`.

# AuxKit MCP Server

Native [Model Context Protocol](https://modelcontextprotocol.io) server that exposes all AuxKit functionality as MCP tools over stdio. This lets AI agents (Claude Desktop, Claude Code, etc.) control Apple Music programmatically.

## Architecture

```
AuxMCPServer
├── AuxToolRegistry          # Central registry, aggregates all tool groups
│   └── AuxToolDefinition    # Declarative tool definition (name, schema, execute closure)
├── MCPSchemaHelpers          # DSL for building JSON Schema input schemas
├── CaptureOutputWriter       # Captures handler JSON output for tool results
└── Tools/                    # 100 tools across 12 groups
    ├── AuthTools             #   3 — status, request, token
    ├── SearchTools           #  10 — songs, albums, artists, playlists, etc.
    ├── CatalogTools          #  20 — catalog lookups, charts, genres
    ├── LibraryTools          #  31 — library CRUD, playlists, imports
    ├── PlaybackTools         #  21 — transport, queue, AirPlay, EQ, shuffle
    ├── RecommendationsTools  #   1 — personal recommendations
    ├── RecentlyPlayedTools   #   2 — recently played tracks/stations
    ├── RatingsTools          #   3 — get/set/delete ratings
    ├── APITools              #   4 — raw MusicDataRequest access
    ├── HistoryTools          #   3 — heavy rotation, history
    ├── FavoritesTools        #   1 — favorites management
    └── SummariesTools        #   1 — listening summaries
```

## How It Works

1. **`AuxMCPServer`** creates an MCP `Server` instance and registers `ListTools` / `CallTool` handlers.
2. **`AuxToolRegistry`** collects `AuxToolDefinition` arrays from each tool group (e.g., `Self.authTools()`, `Self.libraryTools()`).
3. On `CallTool`, the registry looks up the tool by name, calls its `execute` closure with the `ServiceContainer` and parsed arguments, and returns the JSON result.
4. Each tool's `execute` closure instantiates the appropriate AuxKit handler, runs it with a `CaptureOutputWriter`, and returns the captured JSON string.
5. Errors are caught and returned as structured `CLIErrorResponse` JSON with `isError: true`.

## Key Types

| Type | Role |
|------|------|
| `AuxMCPServer` | Entry point — creates server, registers handlers, manages lifecycle |
| `AuxToolDefinition` | Declarative tool: name, description, JSON Schema, execute closure |
| `AuxToolRegistry` | Aggregates all tool definitions, provides lookup by name |
| `MCPSchema` | DSL for building JSON Schema `Value` objects (`string`, `integer`, `boolean`, `object`, `stringEnum`, `stringArray`, etc.) |
| `CaptureOutputWriter` | Implements `OutputWriterProtocol` to capture handler output as a string instead of writing to stdout |

## Adding a New Tool Group

1. Create `Tools/FooTools.swift` with an extension on `AuxToolRegistry`:

```swift
extension AuxToolRegistry {
    static func fooTools() -> [AuxToolDefinition] {
        [
            AuxToolDefinition(
                name: "aux_foo_bar",
                description: "Does bar in the foo domain",
                inputSchema: MCPSchema.object(
                    properties: ["baz": MCPSchema.string("The baz parameter")],
                    required: ["baz"]
                )
            ) { services, args in
                let baz = args?["baz"]?.stringValue ?? ""
                let writer = CaptureOutputWriter()
                let handler = FooBarHandler(services: services)
                try await handler.run(baz: baz, outputWriter: writer)
                return writer.capturedString ?? "{}"
            },
        ]
    }
}
```

2. Add `+ Self.fooTools()` to the `allTools` array in `AuxToolRegistry.init()`.

## Running

```bash
aux mcp serve
```

The server communicates over stdin/stdout using the MCP JSON-RPC protocol. Configure it in Claude Desktop or Claude Code as described in the project root `CLAUDE.md`.

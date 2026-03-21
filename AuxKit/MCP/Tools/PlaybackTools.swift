import Foundation
import MCP

extension AuxToolRegistry {
    static func playbackTools() -> [AuxToolDefinition] {
        [
            // MARK: - aux_playback_play
            AuxToolDefinition(
                name: "aux_playback_play",
                description: "Start or resume playback, optionally playing a specific track",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Database ID of track to play (omit to resume)")
                    ]
                )
            ) { services, args in
                let trackId = args?["track_id"]?.intValue
                let writer = CaptureOutputWriter()
                try await PlayHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    trackId: trackId,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_pause
            AuxToolDefinition(
                name: "aux_playback_pause",
                description: "Pause playback",
                inputSchema: MCPSchema.object(properties: [:])
            ) { services, _ in
                let writer = CaptureOutputWriter()
                try await PauseHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_stop
            AuxToolDefinition(
                name: "aux_playback_stop",
                description: "Stop playback",
                inputSchema: MCPSchema.object(properties: [:])
            ) { services, _ in
                let writer = CaptureOutputWriter()
                try await StopHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_next
            AuxToolDefinition(
                name: "aux_playback_next",
                description: "Skip to the next track",
                inputSchema: MCPSchema.object(properties: [:])
            ) { services, _ in
                let writer = CaptureOutputWriter()
                try await NextHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_previous
            AuxToolDefinition(
                name: "aux_playback_previous",
                description: "Go to the previous track",
                inputSchema: MCPSchema.object(properties: [:])
            ) { services, _ in
                let writer = CaptureOutputWriter()
                try await PreviousHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_now_playing
            AuxToolDefinition(
                name: "aux_playback_now_playing",
                description: "Get the currently playing track",
                inputSchema: MCPSchema.object(properties: [:]),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, _ in
                let writer = CaptureOutputWriter()
                try await NowPlayingHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_player_status
            AuxToolDefinition(
                name: "aux_playback_player_status",
                description: "Get player status including shuffle, repeat, and volume",
                inputSchema: MCPSchema.object(properties: [:]),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, _ in
                let writer = CaptureOutputWriter()
                try await PlayerStatusHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_seek
            AuxToolDefinition(
                name: "aux_playback_seek",
                description: "Seek to a position in the current track",
                inputSchema: MCPSchema.object(
                    properties: [
                        "position": MCPSchema.number("Position in seconds to seek to")
                    ],
                    required: ["position"]
                )
            ) { services, args in
                guard let position = args?["position"].flatMap({ Double($0) }) else {
                    throw AuxError.usageError(message: "Missing required argument: position")
                }
                let writer = CaptureOutputWriter()
                try await SeekHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    position: position,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_volume
            AuxToolDefinition(
                name: "aux_playback_volume",
                description: "Set the player volume (0-100)",
                inputSchema: MCPSchema.object(
                    properties: [
                        "level": MCPSchema.number("Volume level (0-100)")
                    ],
                    required: ["level"]
                )
            ) { services, args in
                guard let level = args?["level"].flatMap({ Double($0) }) else {
                    throw AuxError.usageError(message: "Missing required argument: level")
                }
                let writer = CaptureOutputWriter()
                try await VolumeHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    volume: level,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_shuffle
            AuxToolDefinition(
                name: "aux_playback_shuffle",
                description: "Enable or disable shuffle mode",
                inputSchema: MCPSchema.object(
                    properties: [
                        "enabled": MCPSchema.boolean("Whether to enable shuffle")
                    ],
                    required: ["enabled"]
                )
            ) { services, args in
                guard let enabled = args?["enabled"]?.boolValue else {
                    throw AuxError.usageError(message: "Missing required argument: enabled")
                }
                let writer = CaptureOutputWriter()
                try await ShuffleHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    enabled: enabled,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_repeat
            AuxToolDefinition(
                name: "aux_playback_repeat",
                description: "Set the repeat mode (off, one, all)",
                inputSchema: MCPSchema.object(
                    properties: [
                        "mode": MCPSchema.string("Repeat mode: off, one, or all")
                    ],
                    required: ["mode"]
                )
            ) { services, args in
                guard let mode = args?["mode"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: mode")
                }
                let writer = CaptureOutputWriter()
                try await RepeatHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    mode: mode,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_fast_forward
            AuxToolDefinition(
                name: "aux_playback_fast_forward",
                description: "Skip forward by a number of seconds in the current track",
                inputSchema: MCPSchema.object(
                    properties: [
                        "seconds": MCPSchema.number("Number of seconds to skip forward (default 15)")
                    ]
                )
            ) { services, args in
                let seconds = args?["seconds"]?.doubleValue ?? 15.0
                let writer = CaptureOutputWriter()
                try await FastForwardHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    seconds: seconds,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_rewind
            AuxToolDefinition(
                name: "aux_playback_rewind",
                description: "Skip backward by a number of seconds in the current track",
                inputSchema: MCPSchema.object(
                    properties: [
                        "seconds": MCPSchema.number("Number of seconds to skip backward (default 15)")
                    ]
                )
            ) { services, args in
                let seconds = args?["seconds"]?.doubleValue ?? 15.0
                let writer = CaptureOutputWriter()
                try await RewindHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    seconds: seconds,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_play_next
            AuxToolDefinition(
                name: "aux_playback_play_next",
                description: "Add a track as next in the play queue",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Database ID of track to play next")
                    ],
                    required: ["track_id"]
                )
            ) { services, args in
                guard let trackId = args?["track_id"]?.intValue else {
                    throw AuxError.usageError(message: "Missing required argument: track_id")
                }
                let writer = CaptureOutputWriter()
                try await PlayNextHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    trackId: trackId,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_add_to_queue
            AuxToolDefinition(
                name: "aux_playback_add_to_queue",
                description: "Append a track to the end of the play queue",
                inputSchema: MCPSchema.object(
                    properties: [
                        "track_id": MCPSchema.integer("Database ID of track to add to queue")
                    ],
                    required: ["track_id"]
                )
            ) { services, args in
                guard let trackId = args?["track_id"]?.intValue else {
                    throw AuxError.usageError(message: "Missing required argument: track_id")
                }
                let writer = CaptureOutputWriter()
                try await AddToQueueHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    trackId: trackId,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_airplay_list
            AuxToolDefinition(
                name: "aux_playback_airplay_list",
                description: "List available AirPlay devices",
                inputSchema: MCPSchema.object(properties: [:]),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, _ in
                let writer = CaptureOutputWriter()
                try await AirPlayListHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_airplay_select
            AuxToolDefinition(
                name: "aux_playback_airplay_select",
                description: "Select an AirPlay device for audio output",
                inputSchema: MCPSchema.object(
                    properties: [
                        "name": MCPSchema.string("Name of the AirPlay device to select")
                    ],
                    required: ["name"]
                )
            ) { services, args in
                guard let name = args?["name"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: name")
                }
                let writer = CaptureOutputWriter()
                try await AirPlaySelectHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    name: name,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_airplay_current
            AuxToolDefinition(
                name: "aux_playback_airplay_current",
                description: "Get the currently selected AirPlay device",
                inputSchema: MCPSchema.object(properties: [:]),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, _ in
                let writer = CaptureOutputWriter()
                try await AirPlayCurrentHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_eq_list_presets
            AuxToolDefinition(
                name: "aux_playback_eq_list_presets",
                description: "List available EQ presets",
                inputSchema: MCPSchema.object(properties: [:]),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, _ in
                let writer = CaptureOutputWriter()
                try await EQListPresetsHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_eq_get
            AuxToolDefinition(
                name: "aux_playback_eq_get",
                description: "Get the current EQ preset and enabled state",
                inputSchema: MCPSchema.object(properties: [:]),
                annotations: Tool.Annotations(readOnlyHint: true)
            ) { services, _ in
                let writer = CaptureOutputWriter()
                try await EQGetHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },

            // MARK: - aux_playback_eq_set
            AuxToolDefinition(
                name: "aux_playback_eq_set",
                description: "Set the EQ preset",
                inputSchema: MCPSchema.object(
                    properties: [
                        "preset": MCPSchema.string("Name of the EQ preset to apply")
                    ],
                    required: ["preset"]
                )
            ) { services, args in
                guard let preset = args?["preset"]?.stringValue else {
                    throw AuxError.usageError(message: "Missing required argument: preset")
                }
                let writer = CaptureOutputWriter()
                try await EQSetHandler.handle(
                    services: services,
                    options: GlobalOptions(pretty: true),
                    preset: preset,
                    writer: writer
                )
                return writer.capturedString ?? "{}"
            },
        ]
    }
}

import Testing
import MCP
@testable import AuxKit

@Suite("Playback MCP Tools Tests")
struct PlaybackToolsTests {
    @Test("playback tools returns 21 tools")
    func toolCount() {
        let tools = AuxToolRegistry.playbackTools()
        #expect(tools.count == 21)
    }

    @Test("all playback tools have correct prefix")
    func toolNaming() {
        for tool in AuxToolRegistry.playbackTools() {
            #expect(tool.name.hasPrefix("aux_playback_"))
        }
    }

    @Test("playback tool names are correct")
    func expectedToolNames() {
        let tools = AuxToolRegistry.playbackTools()
        let names = Set(tools.map(\.name))
        let expected: Set<String> = [
            "aux_playback_play",
            "aux_playback_pause",
            "aux_playback_stop",
            "aux_playback_next",
            "aux_playback_previous",
            "aux_playback_now_playing",
            "aux_playback_player_status",
            "aux_playback_seek",
            "aux_playback_volume",
            "aux_playback_shuffle",
            "aux_playback_repeat",
            "aux_playback_fast_forward",
            "aux_playback_rewind",
            "aux_playback_play_next",
            "aux_playback_add_to_queue",
            "aux_playback_airplay_list",
            "aux_playback_airplay_select",
            "aux_playback_airplay_current",
            "aux_playback_eq_list_presets",
            "aux_playback_eq_get",
            "aux_playback_eq_set",
        ]
        #expect(names == expected)
    }

    @Test("read-only tools have readOnlyHint annotation")
    func readOnlyAnnotations() {
        let tools = AuxToolRegistry.playbackTools()
        let readOnlyNames: Set<String> = [
            "aux_playback_now_playing",
            "aux_playback_player_status",
            "aux_playback_airplay_list",
            "aux_playback_airplay_current",
            "aux_playback_eq_list_presets",
            "aux_playback_eq_get",
        ]
        for tool in tools {
            if readOnlyNames.contains(tool.name) {
                #expect(tool.annotations?.readOnlyHint == true,
                        "\(tool.name) should be read-only")
            } else {
                let isReadOnly = tool.annotations?.readOnlyHint ?? false
                #expect(!isReadOnly,
                        "\(tool.name) should not be read-only")
            }
        }
    }

    @Test("aux_playback_pause executes with mock")
    func pauseExecution() async throws {
        let tools = AuxToolRegistry.playbackTools()
        let tool = try #require(tools.first { $0.name == "aux_playback_pause" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            nil
        )
        #expect(result.contains("Playback paused") || result.contains("\"data\""))
    }

    @Test("aux_playback_stop executes with mock")
    func stopExecution() async throws {
        let tools = AuxToolRegistry.playbackTools()
        let tool = try #require(tools.first { $0.name == "aux_playback_stop" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            nil
        )
        #expect(result.contains("Playback stopped") || result.contains("\"data\""))
    }

    @Test("aux_playback_now_playing executes with mock")
    func nowPlayingExecution() async throws {
        let tools = AuxToolRegistry.playbackTools()
        let tool = try #require(tools.first { $0.name == "aux_playback_now_playing" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            nil
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_playback_shuffle executes with mock")
    func shuffleExecution() async throws {
        let tools = AuxToolRegistry.playbackTools()
        let tool = try #require(tools.first { $0.name == "aux_playback_shuffle" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["enabled": .bool(true)]
        )
        #expect(result.contains("Shuffle") || result.contains("\"data\""))
    }

    @Test("aux_playback_volume executes with mock")
    func volumeExecution() async throws {
        let tools = AuxToolRegistry.playbackTools()
        let tool = try #require(tools.first { $0.name == "aux_playback_volume" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["level": .int(75)]
        )
        #expect(result.contains("Volume") || result.contains("\"data\""))
    }

    @Test("aux_playback_eq_get executes with mock")
    func eqGetExecution() async throws {
        let tools = AuxToolRegistry.playbackTools()
        let tool = try #require(tools.first { $0.name == "aux_playback_eq_get" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            nil
        )
        #expect(result.contains("\"data\""))
    }

    @Test("write tools do not have readOnlyHint")
    func writeToolsNotReadOnly() {
        let tools = AuxToolRegistry.playbackTools()
        let writeNames: Set<String> = [
            "aux_playback_play",
            "aux_playback_pause",
            "aux_playback_stop",
            "aux_playback_next",
            "aux_playback_previous",
            "aux_playback_seek",
            "aux_playback_volume",
            "aux_playback_shuffle",
            "aux_playback_repeat",
            "aux_playback_fast_forward",
            "aux_playback_rewind",
            "aux_playback_play_next",
            "aux_playback_add_to_queue",
            "aux_playback_airplay_select",
            "aux_playback_eq_set",
        ]
        for tool in tools where writeNames.contains(tool.name) {
            let isReadOnly = tool.annotations?.readOnlyHint ?? false
            #expect(!isReadOnly, "\(tool.name) should not be read-only")
        }
    }

    // MARK: - Argument Validation Tests (Bug-Fix Validation)

    @Test("aux_playback_fast_forward succeeds with int seconds")
    func fastForwardWithInt() async throws {
        let tools = AuxToolRegistry.playbackTools()
        let tool = try #require(tools.first { $0.name == "aux_playback_fast_forward" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["seconds": .int(30)]
        )
        #expect(result.contains("Fast forward") || result.contains("\"data\""))
    }

    @Test("aux_playback_rewind succeeds with int seconds")
    func rewindWithInt() async throws {
        let tools = AuxToolRegistry.playbackTools()
        let tool = try #require(tools.first { $0.name == "aux_playback_rewind" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["seconds": .int(10)]
        )
        #expect(result.contains("Rewind") || result.contains("\"data\""))
    }

    @Test("aux_playback_seek throws on missing required args")
    func seekMissingArgs() async {
        let tools = AuxToolRegistry.playbackTools()
        let tool = tools.first { $0.name == "aux_playback_seek" }!
        await #expect(throws: AuxError.self) {
            _ = try await tool.execute(ServiceContainer.mock(), nil)
        }
    }

    @Test("aux_playback_seek accepts position as int")
    func seekPositionAsInt() async throws {
        let tools = AuxToolRegistry.playbackTools()
        let tool = try #require(tools.first { $0.name == "aux_playback_seek" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["position": .int(120)]
        )
        #expect(result.contains("Seek") || result.contains("\"data\""))
    }

    @Test("aux_playback_volume throws on missing required args")
    func volumeMissingArgs() async {
        let tools = AuxToolRegistry.playbackTools()
        let tool = tools.first { $0.name == "aux_playback_volume" }!
        await #expect(throws: AuxError.self) {
            _ = try await tool.execute(ServiceContainer.mock(), nil)
        }
    }

    @Test("aux_playback_shuffle throws on missing required args")
    func shuffleMissingArgs() async {
        let tools = AuxToolRegistry.playbackTools()
        let tool = tools.first { $0.name == "aux_playback_shuffle" }!
        await #expect(throws: AuxError.self) {
            _ = try await tool.execute(ServiceContainer.mock(), nil)
        }
    }

    @Test("aux_playback_repeat throws on missing required args")
    func repeatMissingArgs() async {
        let tools = AuxToolRegistry.playbackTools()
        let tool = tools.first { $0.name == "aux_playback_repeat" }!
        await #expect(throws: AuxError.self) {
            _ = try await tool.execute(ServiceContainer.mock(), nil)
        }
    }
}

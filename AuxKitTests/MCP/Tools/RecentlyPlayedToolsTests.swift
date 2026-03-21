import Testing
import MCP
@testable import AuxKit

@Suite("Recently Played MCP Tools Tests")
struct RecentlyPlayedToolsTests {
    @Test("recently played tools returns 2 tools")
    func toolCount() {
        let tools = AuxToolRegistry.recentlyPlayedTools()
        #expect(tools.count == 2)
    }

    @Test("tool names have correct prefix")
    func toolNaming() {
        for tool in AuxToolRegistry.recentlyPlayedTools() {
            #expect(tool.name.hasPrefix("aux_recently_played_"))
        }
    }

    @Test("all recently played tools are read-only")
    func readOnlyAnnotations() {
        for tool in AuxToolRegistry.recentlyPlayedTools() {
            #expect(tool.annotations?.readOnlyHint == true)
        }
    }

    @Test("tool names are correct")
    func expectedToolNames() {
        let names = Set(AuxToolRegistry.recentlyPlayedTools().map(\.name))
        let expected: Set<String> = [
            "aux_recently_played_tracks",
            "aux_recently_played_containers",
        ]
        #expect(names == expected)
    }

    @Test("aux_recently_played_tracks executes with mock")
    func tracksExecution() async throws {
        let tools = AuxToolRegistry.recentlyPlayedTools()
        let tool = try #require(tools.first { $0.name == "aux_recently_played_tracks" })
        let result = try await tool.execute(ServiceContainer.mock(), nil)
        #expect(result.contains("\"data\""))
    }

    @Test("aux_recently_played_containers executes with mock")
    func containersExecution() async throws {
        let tools = AuxToolRegistry.recentlyPlayedTools()
        let tool = try #require(tools.first { $0.name == "aux_recently_played_containers" })
        let result = try await tool.execute(ServiceContainer.mock(), nil)
        #expect(result.contains("\"data\""))
    }
}

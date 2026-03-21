import Testing
import MCP
@testable import AuxKit

@Suite("History MCP Tools Tests")
struct HistoryToolsTests {
    @Test("history tools returns 3 tools")
    func toolCount() {
        let tools = AuxToolRegistry.historyTools()
        #expect(tools.count == 3)
    }

    @Test("tool names have correct prefix")
    func toolNaming() {
        for tool in AuxToolRegistry.historyTools() {
            #expect(tool.name.hasPrefix("aux_history_"))
        }
    }

    @Test("all history tools are read-only")
    func readOnlyAnnotations() {
        for tool in AuxToolRegistry.historyTools() {
            #expect(tool.annotations?.readOnlyHint == true)
        }
    }

    @Test("tool names are correct")
    func expectedToolNames() {
        let names = Set(AuxToolRegistry.historyTools().map(\.name))
        let expected: Set<String> = [
            "aux_history_heavy_rotation",
            "aux_history_recently_played_stations",
            "aux_history_recently_added",
        ]
        #expect(names == expected)
    }

    @Test("aux_history_heavy_rotation executes with mock")
    func heavyRotationExecution() async throws {
        let tools = AuxToolRegistry.historyTools()
        let tool = try #require(tools.first { $0.name == "aux_history_heavy_rotation" })
        let result = try await tool.execute(ServiceContainer.mock(), nil)
        #expect(result.contains("\"data\""))
    }

    @Test("aux_history_recently_played_stations executes with mock")
    func recentlyPlayedStationsExecution() async throws {
        let tools = AuxToolRegistry.historyTools()
        let tool = try #require(tools.first { $0.name == "aux_history_recently_played_stations" })
        let result = try await tool.execute(ServiceContainer.mock(), nil)
        #expect(result.contains("\"data\""))
    }

    @Test("aux_history_recently_added executes with mock")
    func recentlyAddedExecution() async throws {
        let tools = AuxToolRegistry.historyTools()
        let tool = try #require(tools.first { $0.name == "aux_history_recently_added" })
        let result = try await tool.execute(ServiceContainer.mock(), nil)
        #expect(result.contains("\"data\""))
    }

    @Test("aux_history_heavy_rotation succeeds with nil args")
    func heavyRotationNilArgs() async throws {
        let tools = AuxToolRegistry.historyTools()
        let tool = try #require(tools.first { $0.name == "aux_history_heavy_rotation" })
        let result = try await tool.execute(ServiceContainer.mock(), nil)
        #expect(result.contains("\"data\""))
    }

    @Test("aux_history_heavy_rotation accepts limit as double")
    func heavyRotationLimitAsDouble() async throws {
        let tools = AuxToolRegistry.historyTools()
        let tool = try #require(tools.first { $0.name == "aux_history_heavy_rotation" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["limit": .double(10.0)]
        )
        #expect(result.contains("\"data\""))
    }
}

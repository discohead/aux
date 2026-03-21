import Testing
import MCP
@testable import AuxKit

@Suite("Summaries MCP Tools Tests")
struct SummariesToolsTests {
    @Test("summaries tools returns 1 tool")
    func toolCount() {
        let tools = AuxToolRegistry.summariesTools()
        #expect(tools.count == 1)
    }

    @Test("tool name has correct prefix")
    func toolNaming() {
        for tool in AuxToolRegistry.summariesTools() {
            #expect(tool.name.hasPrefix("aux_summaries_"))
        }
    }

    @Test("aux_summaries_get is read-only")
    func readOnlyAnnotation() {
        let tools = AuxToolRegistry.summariesTools()
        let tool = tools.first { $0.name == "aux_summaries_get" }
        #expect(tool?.annotations?.readOnlyHint == true)
    }

    @Test("aux_summaries_get executes with mock")
    func getExecution() async throws {
        let tools = AuxToolRegistry.summariesTools()
        let tool = try #require(tools.first { $0.name == "aux_summaries_get" })
        let result = try await tool.execute(ServiceContainer.mock(), nil)
        #expect(result.contains("\"data\""))
    }

    @Test("aux_summaries_get accepts year and views")
    func getWithArgs() async throws {
        let tools = AuxToolRegistry.summariesTools()
        let tool = try #require(tools.first { $0.name == "aux_summaries_get" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            [
                "year": .string("2024"),
                "views": .array([.string("top-songs"), .string("top-artists")]),
            ]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_summaries_get succeeds with nil args")
    func getNilArgs() async throws {
        let tools = AuxToolRegistry.summariesTools()
        let tool = try #require(tools.first { $0.name == "aux_summaries_get" })
        let result = try await tool.execute(ServiceContainer.mock(), nil)
        #expect(result.contains("\"data\""))
    }
}

import Testing
import MCP
@testable import AuxKit

@Suite("Recommendations MCP Tools Tests")
struct RecommendationsToolsTests {
    @Test("recommendations tools returns 1 tool")
    func toolCount() {
        let tools = AuxToolRegistry.recommendationsTools()
        #expect(tools.count == 1)
    }

    @Test("tool name has correct prefix")
    func toolNaming() {
        for tool in AuxToolRegistry.recommendationsTools() {
            #expect(tool.name.hasPrefix("aux_recommendations_"))
        }
    }

    @Test("aux_recommendations_list is read-only")
    func readOnlyAnnotation() {
        let tools = AuxToolRegistry.recommendationsTools()
        let tool = tools.first { $0.name == "aux_recommendations_list" }
        #expect(tool?.annotations?.readOnlyHint == true)
    }

    @Test("aux_recommendations_list executes with mock")
    func listExecution() async throws {
        let tools = AuxToolRegistry.recommendationsTools()
        let tool = try #require(tools.first { $0.name == "aux_recommendations_list" })
        let result = try await tool.execute(ServiceContainer.mock(), nil)
        #expect(result.contains("\"data\""))
    }

    @Test("aux_recommendations_list accepts limit")
    func listWithLimit() async throws {
        let tools = AuxToolRegistry.recommendationsTools()
        let tool = try #require(tools.first { $0.name == "aux_recommendations_list" })
        let result = try await tool.execute(ServiceContainer.mock(), ["limit": .int(5)])
        #expect(result.contains("\"data\""))
    }
}

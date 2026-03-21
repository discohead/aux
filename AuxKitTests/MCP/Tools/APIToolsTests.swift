import Testing
import MCP
@testable import AuxKit

@Suite("API MCP Tools Tests")
struct APIToolsTests {
    @Test("api tools returns 4 tools")
    func toolCount() {
        let tools = AuxToolRegistry.apiTools()
        #expect(tools.count == 4)
    }

    @Test("tool names have correct prefix")
    func toolNaming() {
        for tool in AuxToolRegistry.apiTools() {
            #expect(tool.name.hasPrefix("aux_api_"))
        }
    }

    @Test("tool names are correct")
    func expectedToolNames() {
        let names = Set(AuxToolRegistry.apiTools().map(\.name))
        let expected: Set<String> = [
            "aux_api_get",
            "aux_api_post",
            "aux_api_put",
            "aux_api_delete",
        ]
        #expect(names == expected)
    }

    @Test("aux_api_get is read-only")
    func getReadOnly() {
        let tools = AuxToolRegistry.apiTools()
        let tool = tools.first { $0.name == "aux_api_get" }
        #expect(tool?.annotations?.readOnlyHint == true)
    }

    @Test("aux_api_delete is destructive")
    func deleteDestructive() {
        let tools = AuxToolRegistry.apiTools()
        let tool = tools.first { $0.name == "aux_api_delete" }
        #expect(tool?.annotations?.destructiveHint == true)
    }

    @Test("all api tools require path")
    func pathRequired() {
        for tool in AuxToolRegistry.apiTools() {
            let schema = tool.inputSchema.objectValue
            let required = schema?["required"]?.arrayValue?.compactMap(\.stringValue)
            #expect(required?.contains("path") == true)
        }
    }

    @Test("aux_api_get executes with mock")
    func getExecution() async throws {
        let tools = AuxToolRegistry.apiTools()
        let tool = try #require(tools.first { $0.name == "aux_api_get" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["path": .string("/v1/catalog/us/songs/123")]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_api_post executes with mock")
    func postExecution() async throws {
        let tools = AuxToolRegistry.apiTools()
        let tool = try #require(tools.first { $0.name == "aux_api_post" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["path": .string("/v1/me/library"), "body": .string("{}")]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_api_delete executes with mock")
    func deleteExecution() async throws {
        let tools = AuxToolRegistry.apiTools()
        let tool = try #require(tools.first { $0.name == "aux_api_delete" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["path": .string("/v1/me/ratings/songs/123")]
        )
        #expect(result.contains("\"data\""))
    }
}

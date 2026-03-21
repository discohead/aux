import Testing
@testable import AuxKit

@Suite("AuxToolDefinition Tests")
struct AuxToolDefinitionTests {

    @Test("tool definition has correct properties")
    func toolDefinitionProperties() {
        let tool = AuxToolDefinition(
            name: "aux_test_tool",
            description: "A test tool",
            inputSchema: MCPSchema.object(
                properties: ["query": MCPSchema.string("Search query")],
                required: ["query"]
            ),
            execute: { _, _ in "result" }
        )
        #expect(tool.name == "aux_test_tool")
        #expect(tool.description == "A test tool")
    }

    @Test("tool execution returns expected output")
    func toolExecution() async throws {
        let tool = AuxToolDefinition(
            name: "aux_echo",
            description: "Echoes input",
            inputSchema: MCPSchema.object(properties: [:]),
            execute: { _, _ in "{\"data\": \"hello\"}" }
        )
        let result = try await tool.execute(ServiceContainer.mock(), nil)
        #expect(result == "{\"data\": \"hello\"}")
    }
}

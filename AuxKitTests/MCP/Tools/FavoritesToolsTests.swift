import Testing
import MCP
@testable import AuxKit

@Suite("Favorites MCP Tools Tests")
struct FavoritesToolsTests {
    @Test("favorites tools returns 1 tool")
    func toolCount() {
        let tools = AuxToolRegistry.favoritesTools()
        #expect(tools.count == 1)
    }

    @Test("tool name has correct prefix")
    func toolNaming() {
        for tool in AuxToolRegistry.favoritesTools() {
            #expect(tool.name.hasPrefix("aux_favorites_"))
        }
    }

    @Test("aux_favorites_add requires type and id")
    func addRequiredParams() {
        let tools = AuxToolRegistry.favoritesTools()
        let tool = tools.first { $0.name == "aux_favorites_add" }
        let schema = tool?.inputSchema.objectValue
        let required = schema?["required"]?.arrayValue?.compactMap(\.stringValue)
        #expect(required?.contains("type") == true)
        #expect(required?.contains("id") == true)
    }

    @Test("aux_favorites_add executes with mock")
    func addExecution() async throws {
        let tools = AuxToolRegistry.favoritesTools()
        let tool = try #require(tools.first { $0.name == "aux_favorites_add" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["type": .string("songs"), "id": .string("123")]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_favorites_add throws on missing required args")
    func addMissingArgs() async {
        let tools = AuxToolRegistry.favoritesTools()
        let tool = tools.first { $0.name == "aux_favorites_add" }!
        await #expect(throws: AuxError.self) {
            _ = try await tool.execute(ServiceContainer.mock(), nil)
        }
    }
}

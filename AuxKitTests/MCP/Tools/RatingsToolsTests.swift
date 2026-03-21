import Testing
import MCP
@testable import AuxKit

@Suite("Ratings MCP Tools Tests")
struct RatingsToolsTests {
    @Test("ratings tools returns 3 tools")
    func toolCount() {
        let tools = AuxToolRegistry.ratingsTools()
        #expect(tools.count == 3)
    }

    @Test("tool names have correct prefix")
    func toolNaming() {
        for tool in AuxToolRegistry.ratingsTools() {
            #expect(tool.name.hasPrefix("aux_ratings_"))
        }
    }

    @Test("tool names are correct")
    func expectedToolNames() {
        let names = Set(AuxToolRegistry.ratingsTools().map(\.name))
        let expected: Set<String> = [
            "aux_ratings_get",
            "aux_ratings_set",
            "aux_ratings_delete",
        ]
        #expect(names == expected)
    }

    @Test("aux_ratings_get is read-only")
    func getReadOnly() {
        let tools = AuxToolRegistry.ratingsTools()
        let tool = tools.first { $0.name == "aux_ratings_get" }
        #expect(tool?.annotations?.readOnlyHint == true)
    }

    @Test("aux_ratings_delete is destructive")
    func deleteDestructive() {
        let tools = AuxToolRegistry.ratingsTools()
        let tool = tools.first { $0.name == "aux_ratings_delete" }
        #expect(tool?.annotations?.destructiveHint == true)
    }

    @Test("aux_ratings_get requires type and id")
    func getRequiredParams() {
        let tools = AuxToolRegistry.ratingsTools()
        let tool = tools.first { $0.name == "aux_ratings_get" }
        let schema = tool?.inputSchema.objectValue
        let required = schema?["required"]?.arrayValue?.compactMap(\.stringValue)
        #expect(required?.contains("type") == true)
        #expect(required?.contains("id") == true)
    }

    @Test("aux_ratings_get executes with mock")
    func getExecution() async throws {
        let tools = AuxToolRegistry.ratingsTools()
        let tool = try #require(tools.first { $0.name == "aux_ratings_get" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["type": .string("songs"), "id": .string("123")]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_ratings_set executes with mock")
    func setExecution() async throws {
        let tools = AuxToolRegistry.ratingsTools()
        let tool = try #require(tools.first { $0.name == "aux_ratings_set" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["type": .string("songs"), "id": .string("123"), "rating": .int(1)]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_ratings_delete executes with mock")
    func deleteExecution() async throws {
        let tools = AuxToolRegistry.ratingsTools()
        let tool = try #require(tools.first { $0.name == "aux_ratings_delete" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["type": .string("songs"), "id": .string("123")]
        )
        #expect(result.contains("\"data\""))
    }

    // MARK: - Argument Validation Tests

    @Test("aux_ratings_get throws on missing required args")
    func getRatingsMissingArgs() async {
        let tools = AuxToolRegistry.ratingsTools()
        let tool = tools.first { $0.name == "aux_ratings_get" }!
        await #expect(throws: AuxError.self) {
            _ = try await tool.execute(ServiceContainer.mock(), nil)
        }
    }

    @Test("aux_ratings_set throws on missing required args")
    func setRatingsMissingArgs() async {
        let tools = AuxToolRegistry.ratingsTools()
        let tool = tools.first { $0.name == "aux_ratings_set" }!
        await #expect(throws: AuxError.self) {
            _ = try await tool.execute(ServiceContainer.mock(), nil)
        }
    }

    @Test("aux_ratings_set accepts rating as double")
    func setRatingsRatingAsDouble() async throws {
        let tools = AuxToolRegistry.ratingsTools()
        let tool = tools.first { $0.name == "aux_ratings_set" }!
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["type": .string("songs"), "id": .string("123"), "rating": .double(1.0)]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_ratings_delete throws on missing required args")
    func deleteRatingsMissingArgs() async {
        let tools = AuxToolRegistry.ratingsTools()
        let tool = tools.first { $0.name == "aux_ratings_delete" }!
        await #expect(throws: AuxError.self) {
            _ = try await tool.execute(ServiceContainer.mock(), nil)
        }
    }
}

//
//  MCPToolFactoriesTests.swift
//  AuxKitTests
//

import Testing
import MCP
@testable import AuxKit

@Suite("MCPToolFactory Tests")
struct MCPToolFactoriesTests {

    @Test("searchTool produces correct name and schema")
    func searchToolNameAndSchema() {
        let tool = MCPToolFactory.searchTool(
            type: "test_items",
            description: "Search test items"
        ) { _, _, _, _, _, _ in }

        #expect(tool.name == "aux_search_test_items")
        #expect(tool.description == "Search test items")
        #expect(tool.annotations?.readOnlyHint == true)
    }

    @Test("searchTool executes with mock services")
    func searchToolExecutes() async throws {
        var receivedQuery: String?
        let tool = MCPToolFactory.searchTool(
            type: "things",
            description: "Search things"
        ) { _, _, query, _, _, writer in
            receivedQuery = query
            let envelope = OutputEnvelope(data: ["found": true])
            try writer.write(envelope)
        }

        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["query": .string("hello")]
        )
        #expect(result.contains("\"data\""))
        #expect(receivedQuery == "hello")
    }

    @Test("searchTool throws on missing query")
    func searchToolMissingQuery() async {
        let tool = MCPToolFactory.searchTool(
            type: "items",
            description: "Search"
        ) { _, _, _, _, _, _ in }

        await #expect(throws: AuxError.self) {
            _ = try await tool.execute(ServiceContainer.mock(), nil)
        }
    }

    @Test("catalogGetById produces correct name and schema")
    func catalogGetByIdNameAndSchema() {
        let tool = MCPToolFactory.catalogGetById(
            type: "widget",
            description: "Get a widget"
        ) { _, _, _, _ in }

        #expect(tool.name == "aux_catalog_widget")
        #expect(tool.description == "Get a widget")
        #expect(tool.annotations?.readOnlyHint == true)
    }

    @Test("catalogGetById executes with mock services")
    func catalogGetByIdExecutes() async throws {
        var receivedId: String?
        let tool = MCPToolFactory.catalogGetById(
            type: "item",
            description: "Get item"
        ) { _, _, id, writer in
            receivedId = id
            let envelope = OutputEnvelope(data: ["id": id])
            try writer.write(envelope)
        }

        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["id": .string("abc123")]
        )
        #expect(result.contains("\"data\""))
        #expect(receivedId == "abc123")
    }

    @Test("catalogGetById throws on missing id")
    func catalogGetByIdMissingId() async {
        let tool = MCPToolFactory.catalogGetById(
            type: "item",
            description: "Get item"
        ) { _, _, _, _ in }

        await #expect(throws: AuxError.self) {
            _ = try await tool.execute(ServiceContainer.mock(), nil)
        }
    }
}

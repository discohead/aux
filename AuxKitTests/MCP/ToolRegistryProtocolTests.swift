//
//  ToolRegistryProtocolTests.swift
//  AuxKitTests
//

import Testing
import MCP
@testable import AuxKit

@Suite("ToolRegistryProtocol Tests")
struct ToolRegistryProtocolTests {

    @Test("AuxToolRegistry conforms to ToolRegistryProtocol")
    func registryConformsToProtocol() {
        let registry: any ToolRegistryProtocol = AuxToolRegistry()
        #expect(registry.allTools().count > 90)
    }

    @Test("AuxToolRegistry init with custom tools")
    func registryWithCustomTools() {
        let tool = AuxToolDefinition(
            name: "aux_test_tool",
            description: "Test",
            inputSchema: MCPSchema.object(properties: [:]),
            execute: { _, _ in "{}" }
        )
        let registry = AuxToolRegistry(tools: [tool])
        #expect(registry.allTools().count == 1)
        #expect(registry.tool(named: "aux_test_tool") != nil)
        #expect(registry.tool(named: "nonexistent") == nil)
    }

    @Test("AuxMCPServer accepts custom registry")
    func serverAcceptsCustomRegistry() async throws {
        let tool = AuxToolDefinition(
            name: "aux_test_echo",
            description: "Echo tool",
            inputSchema: MCPSchema.object(properties: [:]),
            execute: { _, _ in "{\"data\":\"echo\"}" }
        )
        let registry = AuxToolRegistry(tools: [tool])
        let server = AuxMCPServer(services: ServiceContainer.mock(), registry: registry)

        let (clientTransport, serverTransport) = await InMemoryTransport.createConnectedPair()
        try await server.start(transport: serverTransport)

        let client = Client(name: "test-client", version: "1.0.0")
        _ = try await client.connect(transport: clientTransport)

        let result = try await client.listTools()
        #expect(result.tools.count == 1)
        #expect(result.tools.first?.name == "aux_test_echo")

        let callResult = try await client.callTool(name: "aux_test_echo")
        #expect(callResult.isError == false)
        if case .text(let text) = callResult.content.first {
            #expect(text.contains("echo"))
        }

        await server.stop()
    }

    @Test("mcpTools returns correct MCP Tool types")
    func mcpToolsConversion() {
        let tool = AuxToolDefinition(
            name: "aux_test",
            description: "Test tool",
            inputSchema: MCPSchema.object(properties: [:]),
            annotations: Tool.Annotations(readOnlyHint: true),
            execute: { _, _ in "{}" }
        )
        let registry = AuxToolRegistry(tools: [tool])
        let mcpTools = registry.mcpTools()
        #expect(mcpTools.count == 1)
        #expect(mcpTools.first?.name == "aux_test")
        #expect(mcpTools.first?.annotations.readOnlyHint == true)
    }
}

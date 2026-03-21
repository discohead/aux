//
//  AuxMCPServerTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/21/26.
//

import Testing
import MCP
@testable import AuxKit

@Suite("AuxMCPServer Tests")
struct AuxMCPServerTests {

    @Test("server initializes with mock services")
    func serverInitializes() {
        let services = ServiceContainer.mock()
        let server = AuxMCPServer(services: services)
        // Server should be created without throwing
        _ = server
    }

    @Test("server lists tools via MCP protocol")
    func serverListsTools() async throws {
        let services = ServiceContainer.mock()
        let server = AuxMCPServer(services: services)

        let (clientTransport, serverTransport) = await InMemoryTransport.createConnectedPair()

        // Start server in background
        try await server.start(transport: serverTransport)

        // Connect a client
        let client = Client(name: "test-client", version: "1.0.0")
        _ = try await client.connect(transport: clientTransport)

        // List tools
        let result = try await client.listTools()
        #expect(result.tools.count > 90, "Expected more than 90 tools, got \(result.tools.count)")

        await server.stop()
    }

    @Test("server returns error for unknown tool")
    func serverReturnsErrorForUnknownTool() async throws {
        let services = ServiceContainer.mock()
        let server = AuxMCPServer(services: services)

        let (clientTransport, serverTransport) = await InMemoryTransport.createConnectedPair()

        try await server.start(transport: serverTransport)

        let client = Client(name: "test-client", version: "1.0.0")
        _ = try await client.connect(transport: clientTransport)

        // Call a tool that doesn't exist
        let result = try await client.callTool(name: "aux_nonexistent_tool")
        #expect(result.isError == true)

        // Verify the error content contains the tool name
        if case .text(let text) = result.content.first {
            #expect(text.contains("unknown_tool"))
            #expect(text.contains("aux_nonexistent_tool"))
        } else {
            Issue.record("Expected text content in error response")
        }

        await server.stop()
    }

    @Test("server lifecycle: start and stop")
    func serverLifecycle() async throws {
        let services = ServiceContainer.mock()
        let server = AuxMCPServer(services: services)

        let (clientTransport, serverTransport) = await InMemoryTransport.createConnectedPair()

        try await server.start(transport: serverTransport)

        let client = Client(name: "test-client", version: "1.0.0")
        _ = try await client.connect(transport: clientTransport)

        // Verify server responds (listTools works, so server is alive)
        let tools = try await client.listTools()
        #expect(tools.tools.count > 90)

        // Stop and verify no crash
        await server.stop()
    }
}

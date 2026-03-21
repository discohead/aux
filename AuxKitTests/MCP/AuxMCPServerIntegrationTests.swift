import Testing
import MCP
@testable import AuxKit

@Suite("AuxMCPServer Integration Tests")
struct AuxMCPServerIntegrationTests {

    @Test("full client-server roundtrip with mock services")
    func fullRoundtrip() async throws {
        let services = ServiceContainer.mock()
        let server = AuxMCPServer(services: services)

        let (clientTransport, serverTransport) = await InMemoryTransport.createConnectedPair()

        try await server.start(transport: serverTransport)

        let client = Client(name: "integration-test-client", version: "1.0.0")
        _ = try await client.connect(transport: clientTransport)

        // 1. List tools and verify count
        let listResult = try await client.listTools()
        #expect(listResult.tools.count > 90, "Expected more than 90 tools, got \(listResult.tools.count)")

        // 2. Call aux_auth_status — should succeed with JSON data
        let authResult = try await client.callTool(name: "aux_auth_status")
        #expect(authResult.isError != true, "aux_auth_status should not be an error")
        if case .text(let text) = authResult.content.first {
            #expect(text.contains("data"), "auth_status response should contain 'data'")
        } else {
            Issue.record("Expected text content from aux_auth_status")
        }

        // 3. Call aux_search_songs with query argument
        let searchResult = try await client.callTool(
            name: "aux_search_songs",
            arguments: ["query": .string("test")]
        )
        #expect(searchResult.isError != true, "aux_search_songs should not be an error")

        // 4. Call aux_playback_now_playing
        let nowPlayingResult = try await client.callTool(name: "aux_playback_now_playing")
        #expect(nowPlayingResult.isError != true, "aux_playback_now_playing should not be an error")

        // 5. Call unknown tool — should return isError == true
        let unknownResult = try await client.callTool(name: "aux_totally_fake_tool")
        #expect(unknownResult.isError == true, "Unknown tool should return isError")

        await server.stop()
    }
}

import Testing
import MCP
@testable import AuxKit

@Suite("Auth MCP Tools Tests")
struct AuthToolsTests {
    @Test("auth tools returns 3 tools")
    func toolCount() {
        let tools = AuxToolRegistry.authTools()
        #expect(tools.count == 3)
    }

    @Test("tool names are correct")
    func toolNames() {
        let tools = AuxToolRegistry.authTools()
        let names = tools.map(\.name)
        #expect(names.contains("aux_auth_status"))
        #expect(names.contains("aux_auth_request"))
        #expect(names.contains("aux_auth_token"))
    }

    @Test("aux_auth_status is read-only")
    func authStatusAnnotations() {
        let tools = AuxToolRegistry.authTools()
        let tool = tools.first { $0.name == "aux_auth_status" }
        #expect(tool?.annotations?.readOnlyHint == true)
    }

    @Test("aux_auth_token is read-only")
    func authTokenAnnotations() {
        let tools = AuxToolRegistry.authTools()
        let tool = tools.first { $0.name == "aux_auth_token" }
        #expect(tool?.annotations?.readOnlyHint == true)
    }

    @Test("aux_auth_request has no read-only annotation")
    func authRequestAnnotations() {
        let tools = AuxToolRegistry.authTools()
        let tool = tools.first { $0.name == "aux_auth_request" }
        #expect(tool?.annotations == nil)
    }

    @Test("aux_auth_status returns mock data")
    func authStatusExecution() async throws {
        let tools = AuxToolRegistry.authTools()
        let tool = try #require(tools.first { $0.name == "aux_auth_status" })
        let result = try await tool.execute(ServiceContainer.mock(), nil)
        #expect(result.contains("\"data\""))
    }

    @Test("aux_auth_request returns mock data")
    func authRequestExecution() async throws {
        let tools = AuxToolRegistry.authTools()
        let tool = try #require(tools.first { $0.name == "aux_auth_request" })
        let result = try await tool.execute(ServiceContainer.mock(), nil)
        #expect(result.contains("\"data\""))
    }

    @Test("aux_auth_token accepts type argument")
    func authTokenExecution() async throws {
        let tools = AuxToolRegistry.authTools()
        let tool = try #require(tools.first { $0.name == "aux_auth_token" })
        let result = try await tool.execute(ServiceContainer.mock(), ["type": .string("developer")])
        #expect(result.contains("\"data\""))
    }
}

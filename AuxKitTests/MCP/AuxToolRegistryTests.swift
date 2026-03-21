import Testing
@testable import AuxKit

@Suite("AuxToolRegistry Tests")
struct AuxToolRegistryTests {

    @Test("registry initializes with all tool groups")
    func registryInitializes() {
        let registry = AuxToolRegistry()
        let tools = registry.allTools()
        #expect(tools.count >= 90, "Expected at least 90 tools, got \(tools.count)")
    }

    @Test("all tool names follow naming convention")
    func toolNamingConvention() {
        let registry = AuxToolRegistry()
        for tool in registry.allTools() {
            #expect(tool.name.hasPrefix("aux_"), "Tool '\(tool.name)' must start with 'aux_'")
        }
    }

    @Test("lookup by unknown name returns nil")
    func lookupUnknown() {
        let registry = AuxToolRegistry()
        #expect(registry.tool(named: "aux_nonexistent") == nil)
    }

    @Test("lookup by name returns correct tool")
    func lookupByName() {
        let registry = AuxToolRegistry()
        let tool = registry.tool(named: "aux_auth_status")
        #expect(tool != nil)
        #expect(tool?.name == "aux_auth_status")
    }
}

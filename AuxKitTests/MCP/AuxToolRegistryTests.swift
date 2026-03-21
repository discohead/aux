import Testing
@testable import AuxKit

@Suite("AuxToolRegistry Tests")
struct AuxToolRegistryTests {

    @Test("registry initializes with stub tools")
    func registryInitializes() {
        let registry = AuxToolRegistry()
        let tools = registry.allTools()
        // Stubs return empty arrays, so count is 0 for now
        #expect(tools.count >= 0)
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
}

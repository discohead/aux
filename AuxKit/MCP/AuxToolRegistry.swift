import Foundation
import MCP

/// Central registry of all MCP tools. Fails with a precondition if duplicate tool names are detected.
public struct AuxToolRegistry: ToolRegistryProtocol, Sendable {
    private let tools: [AuxToolDefinition]
    private let toolsByName: [String: AuxToolDefinition]

    /// Initialize with all registered tool groups.
    public init() {
        self.init(tools:
            Self.authTools()
            + Self.searchTools()
            + Self.catalogTools()
            + Self.libraryTools()
            + Self.playbackTools()
            + Self.recommendationsTools()
            + Self.recentlyPlayedTools()
            + Self.ratingsTools()
            + Self.apiTools()
            + Self.historyTools()
            + Self.favoritesTools()
            + Self.summariesTools()
        )
    }

    /// Initialize with a custom tool array (for testing or subsets).
    public init(tools allTools: [AuxToolDefinition]) {
        let grouped = Dictionary(grouping: allTools, by: { $0.name })
        let duplicates = grouped.filter { $0.value.count > 1 }.keys.sorted()
        if !duplicates.isEmpty {
            preconditionFailure("AuxToolRegistry contains duplicate tool names: \(duplicates.joined(separator: ", "))")
        }
        self.tools = allTools
        self.toolsByName = Dictionary(uniqueKeysWithValues: allTools.map { ($0.name, $0) })
    }

    public func allTools() -> [AuxToolDefinition] { tools }
    public func tool(named name: String) -> AuxToolDefinition? { toolsByName[name] }
    public func mcpTools() -> [Tool] { tools.map { $0.toMCPTool() } }
}

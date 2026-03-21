import Foundation
import MCP

/// Central registry of all MCP tools.
public struct AuxToolRegistry: Sendable {
    private let tools: [AuxToolDefinition]
    private let toolsByName: [String: AuxToolDefinition]

    public init() {
        let allTools: [AuxToolDefinition] =
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

        self.tools = allTools
        self.toolsByName = Dictionary(uniqueKeysWithValues: allTools.map { ($0.name, $0) })
    }

    public func allTools() -> [AuxToolDefinition] { tools }
    public func tool(named name: String) -> AuxToolDefinition? { toolsByName[name] }
    public func mcpTools() -> [Tool] { tools.map { $0.toMCPTool() } }
}

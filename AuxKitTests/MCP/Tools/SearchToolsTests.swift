import Testing
import MCP
@testable import AuxKit

@Suite("Search MCP Tools Tests")
struct SearchToolsTests {
    @Test("search tools returns 10 tools")
    func toolCount() {
        let tools = AuxToolRegistry.searchTools()
        #expect(tools.count == 10)
    }

    @Test("aux_search_songs executes with mock")
    func searchSongsExecution() async throws {
        let tools = AuxToolRegistry.searchTools()
        let tool = try #require(tools.first { $0.name == "aux_search_songs" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["query": .string("Beatles")]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("all search tools have correct prefix")
    func toolNaming() {
        for tool in AuxToolRegistry.searchTools() {
            #expect(tool.name.hasPrefix("aux_search_"))
        }
    }

    @Test("all search tools are read-only")
    func readOnlyAnnotations() {
        for tool in AuxToolRegistry.searchTools() {
            #expect(tool.annotations?.readOnlyHint == true)
        }
    }

    @Test("all search tools require query parameter")
    func queryRequired() {
        for tool in AuxToolRegistry.searchTools() {
            let schema = tool.inputSchema.objectValue
            let required = schema?["required"]?.arrayValue?.compactMap(\.stringValue)
            #expect(required?.contains("query") == true)
        }
    }

    @Test("search tool names are correct")
    func expectedToolNames() {
        let tools = AuxToolRegistry.searchTools()
        let names = Set(tools.map(\.name))
        let expected: Set<String> = [
            "aux_search_songs",
            "aux_search_albums",
            "aux_search_artists",
            "aux_search_playlists",
            "aux_search_music_videos",
            "aux_search_stations",
            "aux_search_curators",
            "aux_search_radio_shows",
            "aux_search_all",
            "aux_search_suggestions",
        ]
        #expect(names == expected)
    }
}

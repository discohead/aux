import Testing
import MCP
@testable import AuxKit

@Suite("Catalog MCP Tools Tests")
struct CatalogToolsTests {
    @Test("catalog tools returns 20 tools")
    func toolCount() {
        let tools = AuxToolRegistry.catalogTools()
        #expect(tools.count == 20)
    }

    @Test("aux_catalog_song executes with mock")
    func catalogSongExecution() async throws {
        let tools = AuxToolRegistry.catalogTools()
        let tool = try #require(tools.first { $0.name == "aux_catalog_song" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["id": .string("12345")]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("all catalog tools have correct prefix")
    func toolNaming() {
        for tool in AuxToolRegistry.catalogTools() {
            #expect(tool.name.hasPrefix("aux_catalog_"))
        }
    }

    @Test("all catalog tools are read-only")
    func readOnlyAnnotations() {
        for tool in AuxToolRegistry.catalogTools() {
            #expect(tool.annotations?.readOnlyHint == true)
        }
    }

    @Test("catalog tool names are correct")
    func expectedToolNames() {
        let tools = AuxToolRegistry.catalogTools()
        let names = Set(tools.map(\.name))
        let expected: Set<String> = [
            "aux_catalog_song",
            "aux_catalog_song_by_isrc",
            "aux_catalog_album",
            "aux_catalog_album_by_upc",
            "aux_catalog_artist",
            "aux_catalog_playlist",
            "aux_catalog_music_video",
            "aux_catalog_station",
            "aux_catalog_curator",
            "aux_catalog_radio_show",
            "aux_catalog_genre",
            "aux_catalog_all_genres",
            "aux_catalog_record_label",
            "aux_catalog_charts",
            "aux_catalog_storefront",
            "aux_catalog_personal_station",
            "aux_catalog_live_stations",
            "aux_catalog_station_genres",
            "aux_catalog_stations_for_genre",
            "aux_catalog_equivalent",
        ]
        #expect(names == expected)
    }

    @Test("tools with id parameter require it")
    func idRequiredTools() {
        let idRequiredNames: Set<String> = [
            "aux_catalog_song", "aux_catalog_album", "aux_catalog_artist",
            "aux_catalog_playlist", "aux_catalog_music_video", "aux_catalog_station",
            "aux_catalog_curator", "aux_catalog_radio_show", "aux_catalog_genre",
            "aux_catalog_record_label", "aux_catalog_storefront",
        ]
        let tools = AuxToolRegistry.catalogTools()
        for tool in tools where idRequiredNames.contains(tool.name) {
            let schema = tool.inputSchema.objectValue
            let required = schema?["required"]?.arrayValue?.compactMap(\.stringValue)
            #expect(required?.contains("id") == true, "Tool \(tool.name) should require id")
        }
    }
}

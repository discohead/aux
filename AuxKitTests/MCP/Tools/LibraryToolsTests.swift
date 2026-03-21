import Testing
import MCP
@testable import AuxKit

@Suite("Library MCP Tools Tests")
struct LibraryToolsTests {
    @Test("library tools returns 31 tools")
    func toolCount() {
        let tools = AuxToolRegistry.libraryTools()
        #expect(tools.count == 31)
    }

    @Test("all library tools have correct prefix")
    func toolNaming() {
        for tool in AuxToolRegistry.libraryTools() {
            #expect(tool.name.hasPrefix("aux_library_"))
        }
    }

    @Test("library tool names are correct")
    func expectedToolNames() {
        let tools = AuxToolRegistry.libraryTools()
        let names = Set(tools.map(\.name))
        let expected: Set<String> = [
            // Read tools (14)
            "aux_library_songs",
            "aux_library_albums",
            "aux_library_artists",
            "aux_library_playlists",
            "aux_library_music_videos",
            "aux_library_search",
            "aux_library_get_tags",
            "aux_library_get_lyrics",
            "aux_library_get_artwork",
            "aux_library_get_artwork_count",
            "aux_library_get_file_info",
            "aux_library_get_play_stats",
            "aux_library_list_playlists",
            "aux_library_find_duplicates",
            // Write tools (16)
            "aux_library_add",
            "aux_library_create_playlist",
            "aux_library_add_to_playlist",
            "aux_library_set_tags",
            "aux_library_batch_set_tags",
            "aux_library_set_lyrics",
            "aux_library_set_artwork",
            "aux_library_set_play_stats",
            "aux_library_reset_play_stats",
            "aux_library_reveal",
            "aux_library_delete",
            "aux_library_convert",
            "aux_library_import",
            "aux_library_delete_playlist",
            "aux_library_rename_playlist",
            "aux_library_remove_from_playlist",
            "aux_library_reorder_tracks",
        ]
        #expect(names == expected)
    }

    @Test("read-only tools have readOnlyHint annotation")
    func readOnlyAnnotations() {
        let tools = AuxToolRegistry.libraryTools()
        let readOnlyNames: Set<String> = [
            "aux_library_songs",
            "aux_library_albums",
            "aux_library_artists",
            "aux_library_playlists",
            "aux_library_music_videos",
            "aux_library_search",
            "aux_library_get_tags",
            "aux_library_get_lyrics",
            "aux_library_get_artwork",
            "aux_library_get_artwork_count",
            "aux_library_get_file_info",
            "aux_library_get_play_stats",
            "aux_library_list_playlists",
            "aux_library_find_duplicates",
        ]
        for tool in tools {
            if readOnlyNames.contains(tool.name) {
                #expect(tool.annotations?.readOnlyHint == true,
                        "\(tool.name) should be read-only")
            }
        }
    }

    @Test("destructive tools have destructiveHint annotation")
    func destructiveAnnotations() {
        let tools = AuxToolRegistry.libraryTools()
        let destructiveNames: Set<String> = [
            "aux_library_reset_play_stats",
            "aux_library_delete",
            "aux_library_delete_playlist",
        ]
        for tool in tools {
            if destructiveNames.contains(tool.name) {
                #expect(tool.annotations?.destructiveHint == true,
                        "\(tool.name) should be destructive")
            }
        }
    }

    @Test("write tools do not have readOnlyHint")
    func writeToolsNotReadOnly() {
        let tools = AuxToolRegistry.libraryTools()
        let writeNames: Set<String> = [
            "aux_library_add",
            "aux_library_create_playlist",
            "aux_library_add_to_playlist",
            "aux_library_set_tags",
            "aux_library_batch_set_tags",
            "aux_library_set_lyrics",
            "aux_library_set_artwork",
            "aux_library_set_play_stats",
            "aux_library_reset_play_stats",
            "aux_library_reveal",
            "aux_library_delete",
            "aux_library_convert",
            "aux_library_import",
            "aux_library_delete_playlist",
            "aux_library_rename_playlist",
            "aux_library_remove_from_playlist",
            "aux_library_reorder_tracks",
        ]
        for tool in tools where writeNames.contains(tool.name) {
            let isReadOnly = tool.annotations?.readOnlyHint ?? false
            #expect(!isReadOnly, "\(tool.name) should not be read-only")
        }
    }

    @Test("aux_library_list_playlists executes with mock")
    func listPlaylistsExecution() async throws {
        let tools = AuxToolRegistry.libraryTools()
        let tool = try #require(tools.first { $0.name == "aux_library_list_playlists" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            nil
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_library_create_playlist executes with mock")
    func createPlaylistExecution() async throws {
        let tools = AuxToolRegistry.libraryTools()
        let tool = try #require(tools.first { $0.name == "aux_library_create_playlist" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["name": .string("Test Playlist")]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_library_search executes with mock")
    func searchExecution() async throws {
        let tools = AuxToolRegistry.libraryTools()
        let tool = try #require(tools.first { $0.name == "aux_library_search" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["query": .string("test")]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_library_get_tags executes with mock")
    func getTagsExecution() async throws {
        let tools = AuxToolRegistry.libraryTools()
        let tool = try #require(tools.first { $0.name == "aux_library_get_tags" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["track_id": .int(1)]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_library_set_tags executes with mock")
    func setTagsExecution() async throws {
        let tools = AuxToolRegistry.libraryTools()
        let tool = try #require(tools.first { $0.name == "aux_library_set_tags" })
        let result = try await tool.execute(
            ServiceContainer.mock(),
            ["track_id": .int(1), "fields": .object(["name": .string("New Title")])]
        )
        #expect(result.contains("\"data\""))
    }

    @Test("aux_library_songs has no required parameters")
    func songsNoRequired() {
        let tools = AuxToolRegistry.libraryTools()
        let tool = tools.first { $0.name == "aux_library_songs" }!
        let schema = tool.inputSchema.objectValue
        let required = schema?["required"]?.arrayValue?.compactMap(\.stringValue) ?? []
        #expect(required.isEmpty)
    }

    @Test("aux_library_search requires query parameter")
    func searchRequiresQuery() {
        let tools = AuxToolRegistry.libraryTools()
        let tool = tools.first { $0.name == "aux_library_search" }!
        let schema = tool.inputSchema.objectValue
        let required = schema?["required"]?.arrayValue?.compactMap(\.stringValue) ?? []
        #expect(required.contains("query"))
    }
}

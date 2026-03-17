import ArgumentParser

public struct SearchCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "search",
        abstract: "Search the Apple Music catalog",
        subcommands: [
            SearchSongsCommand.self,
            SearchAlbumsCommand.self,
            SearchArtistsCommand.self,
            SearchPlaylistsCommand.self,
            SearchMusicVideosCommand.self,
            SearchStationsCommand.self,
            SearchCuratorsCommand.self,
            SearchRadioShowsCommand.self,
            SearchAllCommand.self,
            SearchSuggestionsCommand.self,
        ]
    )
    public init() {}
}

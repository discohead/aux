import ArgumentParser

public struct LibraryCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "library",
        abstract: "Access and manage your Apple Music library",
        subcommands: [
            LibrarySongsCommand.self,
            LibraryAlbumsCommand.self,
            LibraryArtistsCommand.self,
            LibraryPlaylistsCommand.self,
            LibraryMusicVideosCommand.self,
            LibrarySearchCommand.self,
            LibraryAddCommand.self,
            LibraryCreatePlaylistCommand.self,
            LibraryAddToPlaylistCommand.self,
            LibraryGetTagsCommand.self,
            LibrarySetTagsCommand.self,
            LibraryBatchSetTagsCommand.self,
            LibraryGetLyricsCommand.self,
            LibrarySetLyricsCommand.self,
            LibraryGetArtworkCommand.self,
            LibrarySetArtworkCommand.self,
            LibraryGetArtworkCountCommand.self,
            LibraryGetFileInfoCommand.self,
            LibraryRevealCommand.self,
            LibraryDeleteCommand.self,
            LibraryConvertCommand.self,
            LibraryImportCommand.self,
            LibraryGetPlayStatsCommand.self,
            LibrarySetPlayStatsCommand.self,
            LibraryResetPlayStatsCommand.self,
            LibraryListPlaylistsCommand.self,
            LibraryDeletePlaylistCommand.self,
            LibraryRenamePlaylistCommand.self,
            LibraryRemoveFromPlaylistCommand.self,
            LibraryReorderTracksCommand.self,
            LibraryFindDuplicatesCommand.self,
        ]
    )
    public init() {}
}

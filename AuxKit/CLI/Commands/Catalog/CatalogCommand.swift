import ArgumentParser

public struct CatalogCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "catalog",
        abstract: "Get items from the Apple Music catalog by ID",
        subcommands: [
            CatalogSongCommand.self,
            CatalogSongByISRCCommand.self,
            CatalogAlbumCommand.self,
            CatalogAlbumByUPCCommand.self,
            CatalogArtistCommand.self,
            CatalogPlaylistCommand.self,
            CatalogMusicVideoCommand.self,
            CatalogStationCommand.self,
            CatalogCuratorCommand.self,
            CatalogRadioShowCommand.self,
            CatalogRecordLabelCommand.self,
            CatalogGenreCommand.self,
            CatalogAllGenresCommand.self,
            CatalogChartsCommand.self,
            CatalogStorefrontCommand.self,
            CatalogEquivalentCommand.self,
            CatalogPersonalStationCommand.self,
            CatalogLiveStationsCommand.self,
            CatalogStationGenresCommand.self,
            CatalogStationsForGenreCommand.self,
        ]
    )
    public init() {}
}

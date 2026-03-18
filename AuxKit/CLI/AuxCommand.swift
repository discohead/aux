//
//  AuxCommand.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import ArgumentParser

public struct AuxCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: AuxCommandConfiguration.commandName,
        abstract: AuxCommandConfiguration.abstract,
        version: AuxCommandConfiguration.version,
        subcommands: [
            AuthCommand.self,
            SearchCommand.self,
            CatalogCommand.self,
            LibraryCommand.self,
            PlaybackCommand.self,
            RecommendationsGroupCommand.self,
            RecentlyPlayedCommand.self,
            RatingsCommand.self,
            APICommand.self,
            HistoryCommand.self,
            FavoritesCommand.self,
            SummariesCommand.self,
        ]
    )

    public init() {}

    public func run() async throws {
        print("aux \(Aux.version)")
        print("Run 'aux --help' for usage.")
    }
}

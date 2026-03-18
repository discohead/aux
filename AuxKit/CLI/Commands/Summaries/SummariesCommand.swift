//
//  SummariesCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/17/26.
//

import ArgumentParser

public struct SummariesCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "summaries",
        abstract: "Access Apple Music Summaries (Replay) data",
        subcommands: [
            SummariesGetCommand.self,
        ]
    )
    public init() {}
}

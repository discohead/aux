//
//  PlayerStatusCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct PlayerStatusCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "status",
        abstract: "Get player status (state, shuffle, repeat, volume)"
    )

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await PlayerStatusHandler.handle(services: services, options: options)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}

//
//  ShuffleCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct ShuffleCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "shuffle",
        abstract: "Enable or disable shuffle mode"
    )

    @Option(name: .long, help: "Enable (true) or disable (false) shuffle")
    var enabled: Bool

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await ShuffleHandler.handle(services: services, options: options, enabled: enabled)
    }
    public init() {}
}

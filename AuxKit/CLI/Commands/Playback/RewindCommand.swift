//
//  RewindCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct RewindCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "rewind",
        abstract: "Skip backward by a number of seconds"
    )

    @Option(name: .long, help: "Number of seconds to skip backward")
    var seconds: Double

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await RewindHandler.handle(services: services, options: options, seconds: seconds)
    }
    public init() {}
}

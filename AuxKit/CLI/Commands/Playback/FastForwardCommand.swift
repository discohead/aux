//
//  FastForwardCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct FastForwardCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "fast-forward",
        abstract: "Skip forward by a number of seconds"
    )

    @Option(name: .long, help: "Number of seconds to skip forward")
    var seconds: Double

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live()
        try await FastForwardHandler.handle(services: services, options: options, seconds: seconds)
    }
    public init() {}
}

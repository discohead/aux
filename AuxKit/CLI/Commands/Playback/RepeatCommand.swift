//
//  RepeatCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct RepeatCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "repeat",
        abstract: "Set the repeat mode (off, one, all)"
    )

    @Option(name: .long, help: "Repeat mode: off, one, or all")
    var mode: String

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await RepeatHandler.handle(services: services, options: options, mode: mode)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}

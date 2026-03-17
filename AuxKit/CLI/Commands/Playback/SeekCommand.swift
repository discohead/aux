//
//  SeekCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct SeekCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "seek",
        abstract: "Seek to a position in seconds"
    )

    @Option(name: .long, help: "Position in seconds to seek to")
    var position: Double

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await SeekHandler.handle(services: services, options: options, position: position)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}

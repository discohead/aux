//
//  PlayNextCommand.swift
//  auxCLI
//

import ArgumentParser

public struct PlayNextCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "play-next",
        abstract: "Add a track as next in queue (GUI scripting, requires Accessibility)"
    )

    @Argument(help: "Database ID of the track to play next")
    var trackId: Int

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await PlayNextHandler.handle(services: services, options: options, trackId: trackId)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}

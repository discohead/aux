//
//  AddToQueueCommand.swift
//  auxCLI
//

import ArgumentParser

public struct AddToQueueCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "add-to-queue",
        abstract: "Append a track to the end of the queue (GUI scripting, requires Accessibility)"
    )

    @Argument(help: "Database ID of the track to add to queue")
    var trackId: Int

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await AddToQueueHandler.handle(services: services, options: options, trackId: trackId)
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}

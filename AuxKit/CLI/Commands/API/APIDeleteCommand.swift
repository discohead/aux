//
//  APIDeleteCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct APIDeleteCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "delete",
        abstract: "Make a DELETE request to the Apple Music API"
    )

    @Argument(help: "API path (e.g., /v1/me/ratings/songs/123)")
    var path: String

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live() // placeholder until live services exist
        try await APIDeleteHandler.handle(services: services, options: options, path: path)
    }
    public init() {}
}

//
//  APIPostCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser

public struct APIPostCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "post",
        abstract: "Make a POST request to the Apple Music API"
    )

    @Argument(help: "API path (e.g., /v1/me/library)")
    var path: String

    @Option(name: .long, help: "JSON request body")
    var body: String?

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        let services = ServiceContainer.live() // placeholder until live services exist
        try await APIPostHandler.handle(services: services, options: options, path: path, body: body)
    }
    public init() {}
}

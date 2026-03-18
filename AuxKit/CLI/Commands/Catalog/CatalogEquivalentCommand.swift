//
//  CatalogEquivalentCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/17/26.
//

import ArgumentParser

public struct CatalogEquivalentCommand: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "equivalent",
        abstract: "Find storefront equivalents for a song or album"
    )

    @Option(name: .long, help: "Item type (songs, albums)")
    var type: String

    @Option(name: .long, help: "Target storefront code (e.g. us, gb, jp)")
    var storefront: String

    @Argument(help: "Item ID")
    var id: String

    @Flag(name: .long, help: "Pretty-print JSON output")
    var pretty = false

    @Flag(name: .long, help: "Suppress non-JSON output")
    var quiet = false

    public func run() async throws {
        let options = GlobalOptions(pretty: pretty, quiet: quiet)
        do {
            let services = ServiceContainer.live()
            try await CatalogEquivalentHandler.handle(
                services: services, options: options,
                type: type, id: id, storefront: storefront
            )
        } catch {
            CommandErrorHandler.handle(error, options: options)
        }
    }
    public init() {}
}

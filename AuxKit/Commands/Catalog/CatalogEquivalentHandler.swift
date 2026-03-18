//
//  CatalogEquivalentHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Handler for the `catalog equivalent` command — finds storefront equivalents for songs or albums.
public struct CatalogEquivalentHandler {

    /// Valid Apple Music API resource types for equivalents.
    static let validTypes = ["songs", "albums"]

    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        type: String,
        id: String,
        storefront: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        guard validTypes.contains(type) else {
            throw AuxError.usageError(
                message: "Invalid type '\(type)'. Valid types: \(validTypes.joined(separator: ", "))"
            )
        }

        let path = "/v1/catalog/\(storefront)/\(type)"
        let _ = try await services.restAPI.get(path: path, queryParams: ["filter[equivalents]": id])

        let result = EquivalentResult(type: type)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

//
//  RatingsGetHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `ratings get` command — retrieves a rating for an item.
public struct RatingsGetHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        type: String,
        id: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let path = "/v1/me/ratings/\(type)/\(id)"
        let _ = try await services.restAPI.get(path: path, queryParams: nil)
        let result = RatingResult(updated: true, id: id)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

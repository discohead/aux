//
//  RatingsDeleteHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `ratings delete` command — removes a rating for an item.
public struct RatingsDeleteHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        type: String,
        id: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let path = "/v1/me/ratings/\(type)/\(id)"
        let _ = try await services.restAPI.delete(path: path)
        let result = RatingResult(updated: true, id: id)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

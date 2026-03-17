//
//  RatingsSetHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for the `ratings set` command — sets a rating for an item.
public struct RatingsSetHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        type: String,
        id: String,
        rating: Int,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let path = "/v1/me/ratings/\(type)/\(id)"
        let body = try JSONEncoder().encode(["value": rating])
        let _ = try await services.restAPI.put(path: path, body: body)
        let result = RatingResult(updated: true, id: id, rating: rating)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

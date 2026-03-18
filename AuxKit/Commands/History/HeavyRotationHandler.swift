//
//  HeavyRotationHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Handler for the `history heavy-rotation` command — fetches heavy rotation content.
public struct HeavyRotationHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        limit: Int = 25,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.history.getHeavyRotation(limit: limit)
        let meta = PaginationMeta(limit: limit, offset: 0, total: nil, hasNext: result.items.count == limit)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result, meta: meta))
    }
}

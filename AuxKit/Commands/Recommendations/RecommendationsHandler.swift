//
//  RecommendationsHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for fetching personalized music recommendations.
public struct RecommendationsHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        limit: Int = 10,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.recommendations.getRecommendations(limit: limit)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

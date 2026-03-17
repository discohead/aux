//
//  RecommendationsService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Protocol defining operations for fetching personalized music recommendations.
public protocol RecommendationsService: Sendable {
    func getRecommendations(limit: Int) async throws -> RecommendationsResult
}

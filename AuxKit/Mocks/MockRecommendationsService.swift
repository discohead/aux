//
//  MockRecommendationsService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Mock implementation of RecommendationsService for testing.
public final class MockRecommendationsService: RecommendationsService, @unchecked Sendable {

    // MARK: - Call Tracking

    public var getRecommendationsCalled = false

    // MARK: - Configurable Results

    public var getRecommendationsResult: Result<RecommendationsResult, Error> = .success(
        RecommendationsResult(recommendations: [])
    )

    public init() {}

    // MARK: - Reset

    public func reset() {
        getRecommendationsCalled = false
    }

    // MARK: - Protocol Methods

    public func getRecommendations(limit: Int) async throws -> RecommendationsResult {
        getRecommendationsCalled = true
        return try getRecommendationsResult.get()
    }
}

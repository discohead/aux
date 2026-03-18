//
//  MockSummariesService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Mock implementation of SummariesService for testing.
public final class MockSummariesService: SummariesService, @unchecked Sendable {

    // MARK: - Call Tracking

    public var getMusicSummariesCalled = false
    public var lastYear: String?
    public var lastViews: [String]?

    // MARK: - Configurable Results

    public var getMusicSummariesResult: Result<MusicSummariesResult, Error> = .success(
        MusicSummariesResult(year: "latest", period: nil, topArtists: nil, topAlbums: nil, topSongs: nil)
    )

    public init() {}

    // MARK: - Reset

    public func reset() {
        getMusicSummariesCalled = false
    }

    // MARK: - Protocol Methods

    public func getMusicSummaries(year: String, views: [String]) async throws -> MusicSummariesResult {
        getMusicSummariesCalled = true
        lastYear = year
        lastViews = views
        return try getMusicSummariesResult.get()
    }
}

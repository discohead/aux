//
//  MockRecentlyPlayedService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Mock implementation of RecentlyPlayedService for testing.
public final class MockRecentlyPlayedService: RecentlyPlayedService, @unchecked Sendable {

    // MARK: - Call Tracking

    public var getRecentlyPlayedTracksCalled = false
    public var getRecentlyPlayedContainersCalled = false

    // MARK: - Configurable Results

    public var getRecentlyPlayedTracksResult: Result<[TrackDTO], Error> = .success([])
    public var getRecentlyPlayedContainersResult: Result<RecentlyPlayedContainersResult, Error> = .success(
        RecentlyPlayedContainersResult(items: [])
    )

    public init() {}

    // MARK: - Reset

    public func reset() {
        getRecentlyPlayedTracksCalled = false
        getRecentlyPlayedContainersCalled = false
    }

    // MARK: - Protocol Methods

    public func getRecentlyPlayedTracks(limit: Int) async throws -> [TrackDTO] {
        getRecentlyPlayedTracksCalled = true
        return try getRecentlyPlayedTracksResult.get()
    }

    public func getRecentlyPlayedContainers(limit: Int) async throws -> RecentlyPlayedContainersResult {
        getRecentlyPlayedContainersCalled = true
        return try getRecentlyPlayedContainersResult.get()
    }
}

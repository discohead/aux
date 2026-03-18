//
//  MockHistoryService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Mock implementation of HistoryService for testing.
public final class MockHistoryService: HistoryService, @unchecked Sendable {

    // MARK: - Call Tracking

    public var getHeavyRotationCalled = false
    public var getRecentlyPlayedStationsCalled = false
    public var getRecentlyAddedResourcesCalled = false

    // MARK: - Configurable Results

    public var getHeavyRotationResult: Result<HeavyRotationResult, Error> = .success(
        HeavyRotationResult(items: [])
    )
    public var getRecentlyPlayedStationsResult: Result<[StationDTO], Error> = .success([])
    public var getRecentlyAddedResourcesResult: Result<RecentlyAddedResult, Error> = .success(
        RecentlyAddedResult(items: [])
    )

    public init() {}

    // MARK: - Reset

    public func reset() {
        getHeavyRotationCalled = false
        getRecentlyPlayedStationsCalled = false
        getRecentlyAddedResourcesCalled = false
    }

    // MARK: - Protocol Methods

    public func getHeavyRotation(limit: Int) async throws -> HeavyRotationResult {
        getHeavyRotationCalled = true
        return try getHeavyRotationResult.get()
    }

    public func getRecentlyPlayedStations(limit: Int) async throws -> [StationDTO] {
        getRecentlyPlayedStationsCalled = true
        return try getRecentlyPlayedStationsResult.get()
    }

    public func getRecentlyAddedResources(limit: Int) async throws -> RecentlyAddedResult {
        getRecentlyAddedResourcesCalled = true
        return try getRecentlyAddedResourcesResult.get()
    }
}

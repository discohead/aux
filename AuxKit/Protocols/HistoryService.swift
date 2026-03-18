//
//  HistoryService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Protocol for accessing Apple Music listening history endpoints.
public protocol HistoryService: Sendable {
    func getHeavyRotation(limit: Int) async throws -> HeavyRotationResult
    func getRecentlyPlayedStations(limit: Int) async throws -> [StationDTO]
    func getRecentlyAddedResources(limit: Int) async throws -> RecentlyAddedResult
}

//
//  RecentlyPlayedService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Protocol defining operations for accessing recently played tracks and containers.
public protocol RecentlyPlayedService: Sendable {
    func getRecentlyPlayedTracks(limit: Int) async throws -> [TrackDTO]
    func getRecentlyPlayedContainers(limit: Int) async throws -> RecentlyPlayedContainersResult
}

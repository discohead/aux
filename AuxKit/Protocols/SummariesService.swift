//
//  SummariesService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Protocol for accessing Apple Music Summaries (Replay) endpoints.
public protocol SummariesService: Sendable {
    func getMusicSummaries(year: String, views: [String]) async throws -> MusicSummariesResult
}

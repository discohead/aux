//
//  SummariesGetHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Handler for getting Apple Music Summaries (Replay) data.
public struct SummariesGetHandler {

    /// Valid view parameter values.
    public static let validViews = ["top-artists", "top-albums", "top-songs", "all"]

    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        year: String = "latest",
        views: [String] = ["all"],
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        // Validate view parameters
        for view in views {
            guard validViews.contains(view) else {
                throw AuxError.usageError(message: "Invalid view '\(view)'. Valid values: top-artists, top-albums, top-songs, all")
            }
        }

        // Expand "all" to all three views
        var expandedViews = views
        if expandedViews.contains("all") {
            expandedViews = ["top-artists", "top-albums", "top-songs"]
        }

        let result = try await services.summaries.getMusicSummaries(year: year, views: expandedViews)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

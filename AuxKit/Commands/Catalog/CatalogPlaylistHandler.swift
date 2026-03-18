//
//  CatalogPlaylistHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for getting a playlist from the Apple Music catalog by ID.
public struct CatalogPlaylistHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        id: String,
        include: [String]? = nil,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.catalog.getPlaylist(id: id, include: include)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

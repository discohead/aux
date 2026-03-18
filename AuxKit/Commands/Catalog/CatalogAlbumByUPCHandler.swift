//
//  CatalogAlbumByUPCHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Handler for getting albums from the Apple Music catalog by UPC.
/// Accepts a single UPC or comma-separated UPCs for batch lookup.
public struct CatalogAlbumByUPCHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        upc: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let upcs = upc.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        var allAlbums: [AlbumDTO] = []
        for code in upcs {
            let result = try await services.catalog.getAlbumByUPC(upc: code)
            allAlbums.append(contentsOf: result)
        }
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: allAlbums))
    }
}

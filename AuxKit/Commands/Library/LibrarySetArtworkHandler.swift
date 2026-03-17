//
//  LibrarySetArtworkHandler.swift
//  AuxKit
//

import Foundation

/// Handler for setting track artwork via AppleScript.
public struct LibrarySetArtworkHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        imagePath: String,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        try await services.appleScript.setArtwork(trackId: trackId, imagePath: imagePath)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: LibraryActionResult(message: "Artwork updated for track \(trackId)")))
    }
}

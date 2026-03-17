//
//  LibraryImportHandler.swift
//  AuxKit
//

import Foundation

/// Handler for importing files into the library via AppleScript.
public struct LibraryImportHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        paths: [String],
        toPlaylist: String? = nil,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.appleScript.importFiles(paths: paths, toPlaylist: toPlaylist)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

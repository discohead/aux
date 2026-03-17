//
//  LibraryGetFileInfoHandler.swift
//  AuxKit
//

import Foundation

/// Handler for getting track file info via AppleScript.
public struct LibraryGetFileInfoHandler {
    public static func handle(
        services: ServiceContainer,
        options: GlobalOptions,
        trackId: Int,
        writer: (any OutputWriterProtocol)? = nil
    ) async throws {
        let result = try await services.appleScript.getFileInfo(trackId: trackId)
        let outputWriter = writer ?? options.makeOutputWriter()
        try outputWriter.write(OutputEnvelope(data: result))
    }
}

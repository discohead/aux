//
//  CommandErrorHandler.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/17/26.
//

import Foundation

/// Shared error-handling utility for CLI commands.
/// Converts thrown errors to structured JSON on stderr and exits with the correct AuxExitCode.
public enum CommandErrorHandler {

    /// Converts an error to a CLIErrorResponse, writes JSON to stderr, and exits.
    /// Call this from the catch block of every command's `run()` method.
    public static func handle(_ error: Error, options: GlobalOptions) -> Never {
        let (response, exitCode) = mapError(error)
        writeErrorJSON(response, pretty: options.pretty)
        Foundation.exit(exitCode.rawValue)
    }

    /// Maps an error to a CLIErrorResponse and AuxExitCode without exiting.
    /// Useful for testing.
    public static func mapError(_ error: Error) -> (CLIErrorResponse, AuxExitCode) {
        if let auxError = error as? AuxError {
            return (auxError.toCLIErrorResponse(), auxError.exitCode)
        }
        // Wrap unknown errors as generalFailure
        let wrapped = AuxError.generalFailure(message: error.localizedDescription)
        return (wrapped.toCLIErrorResponse(), wrapped.exitCode)
    }

    /// Writes a CLIErrorResponse as JSON to stderr.
    public static func writeErrorJSON(_ response: CLIErrorResponse, pretty: Bool = false) {
        let encoder = JSONEncoder()
        if pretty {
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        }
        if let data = try? encoder.encode(response) {
            FileHandle.standardError.write(data)
            FileHandle.standardError.write(Data("\n".utf8))
        }
    }
}

//
//  GlobalOptions.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Global CLI options that affect output formatting and verbosity.
public struct GlobalOptions: Sendable {
    public let pretty: Bool
    public let raw: Bool
    public let quiet: Bool

    public init(pretty: Bool = false, raw: Bool = false, quiet: Bool = false) {
        self.pretty = pretty
        self.raw = raw
        self.quiet = quiet
    }

    /// Creates a JSONOutputWriter configured according to these global options.
    public func makeOutputWriter(
        destination: @escaping @Sendable (Data) -> Void = { data in
            FileHandle.standardOutput.write(data)
            FileHandle.standardOutput.write(Data("\n".utf8))
        }
    ) -> JSONOutputWriter {
        JSONOutputWriter(pretty: pretty, destination: destination)
    }

    /// Preset for MCP tool output: pretty-printed JSON.
    public static let pretty = GlobalOptions(pretty: true)

    /// Prints a message to stderr, unless quiet mode is enabled.
    public func stderrPrint(_ message: String) {
        guard !quiet else { return }
        var stream = StderrOutputStream()
        stream.write(message + "\n")
    }
}

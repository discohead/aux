import Foundation

public struct AppleScriptRunner: Sendable {
    public init() {}

    public func execute(_ script: String) async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                var error: NSDictionary?
                let appleScript = NSAppleScript(source: script)
                let result = appleScript?.executeAndReturnError(&error)

                if let error = error {
                    let message = error[NSAppleScript.errorMessage] as? String ?? "Unknown AppleScript error"
                    continuation.resume(throwing: AuxError.appleScriptError(message: message))
                    return
                }

                continuation.resume(returning: result?.stringValue)
            }
        }
    }
}

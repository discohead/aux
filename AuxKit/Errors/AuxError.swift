//
//  AuxError.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Unified error type for all Aux operations.
public enum AuxError: Error, Sendable {
    case notAuthorized(message: String)
    case notFound(message: String)
    case networkError(message: String)
    case serviceError(message: String)
    case subscriptionRequired(message: String)
    case unavailable(message: String)
    case generalFailure(message: String)
    case usageError(message: String)
    case appleScriptError(message: String)

    /// The exit code for this error.
    public var exitCode: AuxExitCode {
        switch self {
        case .notAuthorized: .notAuthorized
        case .notFound: .notFound
        case .networkError: .networkError
        case .serviceError: .serviceError
        case .subscriptionRequired: .subscriptionRequired
        case .unavailable: .unavailable
        case .generalFailure: .generalFailure
        case .usageError: .usageError
        case .appleScriptError: .serviceError
        }
    }

    /// Snake-case error code string for JSON output.
    public var code: String {
        switch self {
        case .notAuthorized: "not_authorized"
        case .notFound: "not_found"
        case .networkError: "network_error"
        case .serviceError: "service_error"
        case .subscriptionRequired: "subscription_required"
        case .unavailable: "unavailable"
        case .generalFailure: "general_failure"
        case .usageError: "usage_error"
        case .appleScriptError: "applescript_error"
        }
    }

    /// The human-readable error message.
    public var message: String {
        switch self {
        case .notAuthorized(let msg),
             .notFound(let msg),
             .networkError(let msg),
             .serviceError(let msg),
             .subscriptionRequired(let msg),
             .unavailable(let msg),
             .generalFailure(let msg),
             .usageError(let msg),
             .appleScriptError(let msg):
            msg
        }
    }

    /// Convert to a CLIErrorResponse for JSON output.
    public func toCLIErrorResponse(details: [String: AnyCodable]? = nil) -> CLIErrorResponse {
        CLIErrorResponse(code: code, message: message, details: details)
    }
}

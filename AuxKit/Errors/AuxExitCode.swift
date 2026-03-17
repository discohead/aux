//
//  AuxExitCode.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Exit codes for the aux CLI, following standard Unix conventions.
public enum AuxExitCode: Int32, CaseIterable, Sendable {
    case success = 0
    case generalFailure = 1
    case usageError = 2
    case notAuthorized = 3
    case notFound = 4
    case networkError = 5
    case serviceError = 6
    case subscriptionRequired = 7
    case unavailable = 8

    /// Snake-case string representation of the exit code.
    public var name: String {
        switch self {
        case .success: "success"
        case .generalFailure: "general_failure"
        case .usageError: "usage_error"
        case .notAuthorized: "not_authorized"
        case .notFound: "not_found"
        case .networkError: "network_error"
        case .serviceError: "service_error"
        case .subscriptionRequired: "subscription_required"
        case .unavailable: "unavailable"
        }
    }
}

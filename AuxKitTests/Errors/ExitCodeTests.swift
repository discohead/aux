//
//  ExitCodeTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct ExitCodeTests {

    @Test func successIsZero() {
        #expect(AuxExitCode.success.rawValue == 0)
    }

    @Test func generalFailureIsOne() {
        #expect(AuxExitCode.generalFailure.rawValue == 1)
    }

    @Test func usageErrorIsTwo() {
        #expect(AuxExitCode.usageError.rawValue == 2)
    }

    @Test func notAuthorizedIsThree() {
        #expect(AuxExitCode.notAuthorized.rawValue == 3)
    }

    @Test func notFoundIsFour() {
        #expect(AuxExitCode.notFound.rawValue == 4)
    }

    @Test func networkErrorIsFive() {
        #expect(AuxExitCode.networkError.rawValue == 5)
    }

    @Test func serviceErrorIsSix() {
        #expect(AuxExitCode.serviceError.rawValue == 6)
    }

    @Test func subscriptionRequiredIsSeven() {
        #expect(AuxExitCode.subscriptionRequired.rawValue == 7)
    }

    @Test func unavailableIsEight() {
        #expect(AuxExitCode.unavailable.rawValue == 8)
    }

    @Test func allCasesHaveUniqueValues() {
        let rawValues = AuxExitCode.allCases.map(\.rawValue)
        #expect(Set(rawValues).count == rawValues.count)
    }

    @Test func nameReturnsSnakeCaseString() {
        #expect(AuxExitCode.success.name == "success")
        #expect(AuxExitCode.generalFailure.name == "general_failure")
        #expect(AuxExitCode.usageError.name == "usage_error")
        #expect(AuxExitCode.notAuthorized.name == "not_authorized")
        #expect(AuxExitCode.notFound.name == "not_found")
        #expect(AuxExitCode.networkError.name == "network_error")
        #expect(AuxExitCode.serviceError.name == "service_error")
        #expect(AuxExitCode.subscriptionRequired.name == "subscription_required")
        #expect(AuxExitCode.unavailable.name == "unavailable")
    }
}

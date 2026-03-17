//
//  SuccessResult.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Generic success result for void-returning commands.
public struct SuccessResult: Codable, Equatable, Sendable {
    public let success: Bool
    public let message: String?

    public init(success: Bool = true, message: String? = nil) {
        self.success = success
        self.message = message
    }
}

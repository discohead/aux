//
//  AuthService.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Protocol defining operations for Apple Music authorization and token management.
public protocol AuthService: Sendable {
    func checkStatus() async throws -> AuthStatusResult
    func requestAuthorization() async throws -> AuthStatusResult
    func getToken(type: String) async throws -> TokenResult
}

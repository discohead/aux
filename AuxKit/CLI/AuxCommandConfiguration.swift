//
//  AuxCommandConfiguration.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

/// Shared constants for the aux CLI command structure.
public enum AuxCommandConfiguration {
    public static let commandName = "aux"
    public static let version = Aux.version
    public static let abstract = "Apple Music CLI — search, browse, play, and manage your library."

    /// The 9 top-level subcommand group names.
    public static let subcommandGroupNames: [String] = [
        "auth",
        "search",
        "catalog",
        "library",
        "playback",
        "recommendations",
        "recently-played",
        "ratings",
        "api",
    ]
}

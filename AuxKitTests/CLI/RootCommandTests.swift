//
//  RootCommandTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct RootCommandTests {

    @Test func commandNameIsAux() {
        #expect(AuxCommandConfiguration.commandName == "aux")
    }

    @Test func versionIs1_1_0() {
        #expect(AuxCommandConfiguration.version == "1.1.0")
    }

    @Test func hasNineSubcommandGroups() {
        let groups = AuxCommandConfiguration.subcommandGroupNames
        #expect(groups.count == 9)
        #expect(groups.contains("auth"))
        #expect(groups.contains("search"))
        #expect(groups.contains("catalog"))
        #expect(groups.contains("library"))
        #expect(groups.contains("playback"))
        #expect(groups.contains("recommendations"))
        #expect(groups.contains("recently-played"))
        #expect(groups.contains("ratings"))
        #expect(groups.contains("api"))
    }
}

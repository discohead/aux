//
//  AuxKitTests.swift
//  AuxKitTests
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation
import Testing
@testable import AuxKit

struct AuxKitTests {

    @Test func versionIsCorrect() {
        #expect(Aux.version == "1.1.0")
    }

}

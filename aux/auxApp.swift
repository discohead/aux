//
//  auxApp.swift
//  aux
//
//  Created by Jared McFarland on 3/15/26.
//

import SwiftUI
import AuxKit

struct auxApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        Settings {
            PreferencesView()
        }
    }
}

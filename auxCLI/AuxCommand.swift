//
//  AuxCommand.swift
//  auxCLI
//
//  Created by Jared McFarland on 3/16/26.
//

import ArgumentParser
import AuxKit

@main
struct AuxCLIMain {
    static func main() async {
        await AuxCommand.main()
    }
}

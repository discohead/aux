//
//  AuxJSONCoding.swift
//  AuxKit
//
//  Created by Jared McFarland on 3/16/26.
//

import Foundation

extension JSONEncoder {
    /// Shared encoder with snake_case key strategy.
    public static var aux: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        return encoder
    }
}

extension JSONDecoder {
    /// Shared decoder with snake_case key strategy.
    public static var aux: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }
}

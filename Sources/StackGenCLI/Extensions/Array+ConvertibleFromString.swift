//
//  File.swift
//  
//
//  Created by Andres Cecilia on 23/05/2020.
//

import Foundation
import SwiftCLI

extension Array: ConvertibleFromString where Element == String {
    public init?(input: String) {
        self = input.components(separatedBy: ",")
    }
}

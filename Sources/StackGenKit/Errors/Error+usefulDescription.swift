//
//  File.swift
//  
//
//  Created by Andres Cecilia on 23/05/2020.
//

import Foundation

private let uselessError = NSRegularExpression(
    #"^The operation couldn’t be completed\. \([^\n]*?\)$"#
)

public extension Error {
    /// The localizedDescription of the error. If not present, the default output will get appended the error description
    var usefulDescription: String {
        var description = localizedDescription

        if uselessError.matches(description) {
            description.append(". \(self)")
        }

        return description
    }
}

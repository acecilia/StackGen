import Foundation
import Mustache
import Yams
import ProjectSpec

// To print a proper error when throwing
// See: https://stackoverflow.com/questions/39176196/how-to-provide-a-localized-description-with-an-error-type-in-swift

public protocol LocalizedErrorDescription: LocalizedError { }

extension LocalizedErrorDescription where Self: CustomStringConvertible {
    public var errorDescription: String? {
        return description
    }
}

// MARK: Conformance for known errors

extension UnexpectedError: LocalizedErrorDescription { }
extension MustacheError: LocalizedErrorDescription { }
extension YamlError: LocalizedErrorDescription { }
extension SpecParsingError: LocalizedErrorDescription { }

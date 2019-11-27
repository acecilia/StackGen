import Foundation

public enum Converter: String, CaseIterable, Codable {
    case xcodegen

    func build() -> ConverterInterface {
        switch self {
        case .xcodegen:
            return XcodeGenConverter()
        }
    }
}


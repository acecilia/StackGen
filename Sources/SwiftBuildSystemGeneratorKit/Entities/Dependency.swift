import Foundation
import Path
import AnyCodable

public enum Dependency: Encodable {
    case module(Module)
    case framework(String)

    private enum CodingKeys: String, CodingKey {
        case type
        case name
    }

    public enum Kind: String, Codable {
        case module
        case framework
    }

    public var type: Kind {
        switch self {
        case .module:
            return .module

        case .framework:
            return .framework
        }
    }

    public func encode(to encoder: Encoder) throws {
        var dict: [String: AnyCodable]

        switch self {
        case let .module(module):
            dict = try module.asDictionary(basePath: encoder.userInfo[.relativePath] as? Path).mapValues {
                AnyCodable($0)
            }
        case let .framework(name):
            dict = [
                CodingKeys.name.rawValue: AnyCodable(name)
            ]
        }

        dict[CodingKeys.type.rawValue] = AnyCodable(type.rawValue)

        var container = encoder.singleValueContainer()
        try container.encode(dict)
    }
}

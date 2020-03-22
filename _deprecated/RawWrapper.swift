import Foundation
import AnyCodable

@propertyWrapper
public struct RawWrapper<T: Codable>: Codable {
    public let raw: [String: String]
    public let typed: T

    public init(from decoder: Decoder) throws {
        typed = try T.init(from: decoder)
        let container = try decoder.singleValueContainer()
        raw = try container.decode([String: String].self)
    }

    public func encode(to encoder: Encoder) throws {
        try typed.encode(to: encoder)
        try raw.encode(to: encoder)
    }

    public var wrappedValue: T { typed }
    public var projectedValue: Self { self }
}


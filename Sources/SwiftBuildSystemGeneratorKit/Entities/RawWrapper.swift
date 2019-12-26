import Foundation
import AnyCodable

@propertyWrapper
public struct RawWrapper<T: DictionaryConvertible & Decodable>: DictionaryConvertible, Decodable {
    public let raw: [String: Any]
    public let typed: T

    public func asDictionary(basePath: Path) throws -> [String: Any] {
        let typedDict = try typed.asDictionary(basePath: basePath)
        let dict = raw.merging(typedDict) { _, new in new }
        return dict
    }

    public init(from decoder: Decoder) throws {
        typed = try T.init(from: decoder)
        let container = try decoder.singleValueContainer()
        raw = try container.decode([String: AnyCodable].self) as [String: Any]
    }

    public var wrappedValue: T { typed }
    public var projectedValue: Self { self }
}


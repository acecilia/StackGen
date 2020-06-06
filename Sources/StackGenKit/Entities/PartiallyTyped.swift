import Foundation

/// An object that is type safe, while at the same time keeps its non type safe representation
public struct PartiallyTyped<Typed, Untyped> {
    public var typed: Typed
    public var untyped: Untyped

    public init(_ typed: Typed, _ untyped: Untyped) {
        self.typed = typed
        self.untyped = untyped
    }
}

extension PartiallyTyped: Encodable where Typed: Encodable, Untyped: Encodable {
    public func encode(to encoder: Encoder) throws {
        try untyped.encode(to: encoder)
        try typed.encode(to: encoder)
    }
}

extension PartiallyTyped: Decodable where Typed: Decodable, Untyped: Decodable {
    public init(from decoder: Decoder) throws {
        self.typed = try Typed(from: decoder)
        self.untyped = try Untyped(from: decoder)
    }
}

extension PartiallyTyped: Equatable where Typed: Equatable, Untyped: Equatable { }

import Foundation

/// A wrapper around the supported modules
public enum Module: Codable {
    /// A first party module
    case firstParty(FirstPartyModule.Output)
    /// A third party module
    case thirdParty(ThirdPartyModule.Output)

    /// The name of the module
    public var name: String {
        switch self {
        case let .firstParty(module):
            return module.name

        case let .thirdParty(module):
            return module.typed.name
        }
    }

    /// The kind of the module
    public var kind: ModuleKind {
        switch self {
        case .firstParty:
            return .firstParty

        case .thirdParty:
            return .thirdParty
        }
    }
}

// MARK: Codable related

extension Module {
    private enum CodingKeys: String, CodingKey {
        case kind
    }

    private var underlyingValue: Codable {
        switch self {
        case let .firstParty(module):
            return module

        case let .thirdParty(module):
            return module
        }
    }

    public func encode(to encoder: Encoder) throws {
        try underlyingValue.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kind, forKey: .kind)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(ModuleKind.self, forKey: .kind)
        switch kind {
        case .firstParty:
            let module = try FirstPartyModule.Output(from: decoder)
            self = .firstParty(module)

        case .thirdParty:
            let module = try ThirdPartyModule.Output(from: decoder)
            self = .thirdParty(module)
        }
    }
}

// MARK: Convenience

extension Array where Element == Module {
    /// Convenient property to filter and map the first party modules
    public var firstParty: [FirstPartyModule.Output] {
        self.compactMap {
            switch $0 {
            case let .firstParty(module):
                return module

            case .thirdParty:
                return nil
            }
        }
    }

    /// Convenient property to filter and map the third party modules
    public var thirdParty: [ThirdPartyModule.Output] {
        self.compactMap {
            switch $0 {
            case let .thirdParty(module):
                return module

            case .firstParty:
                return nil
            }
        }
    }
}

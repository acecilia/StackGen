import Foundation

public enum Module: Codable {
    case firstParty(FirstPartyModule.Output)
    case thirdParty(ThirdPartyModule.Output)

    private enum CodingKeys: String, CodingKey {
        case kind
    }

    public var name: String {
        switch self {
        case let .firstParty(module):
            return module.name

        case let .thirdParty(module):
            return module.name
        }
    }

    public var kind: ModuleKind {
        switch self {
        case let .firstParty(module):
            return module.kind

        case let .thirdParty(module):
            return module.kind
        }
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
        try kind.encode(to: encoder)
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

import Foundation

public enum Dependency {
    public enum Middleware {
        case firstParty(FirstPartyModule.Middleware)
        case thirdParty(ThirdPartyModule.Output)

        public var name: String {
            switch self {
            case .firstParty(let target):
                return target.name

            case .thirdParty(let artifact):
                return artifact.name
            }
        }
    }

    public enum Output: Codable, Hashable {
        case firstParty(FirstPartyModule.Output)
        case thirdParty(ThirdPartyModule.Output)

        private enum CodingKeys: String, CodingKey {
            case type
        }

        public enum Kind: String, Codable, CaseIterable, Comparable {
            case firstParty
            case thirdParty

            public static func < (lhs: Dependency.Output.Kind, rhs: Dependency.Output.Kind) -> Bool {
                return allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
            }
        }

        public var name: String {
            switch self {
            case .firstParty(let module):
                return module.name

            case .thirdParty(let module):
                return module.name
            }
        }

        public var underlyingObject: Codable {
            switch self {
            case .firstParty(let firstPartyModule):
                return firstPartyModule

            case .thirdParty(let thirdPartyModule):
                return thirdPartyModule
            }
        }

        public var type: Kind {
            switch self {
            case .firstParty:
                return .firstParty

            case .thirdParty:
                return .thirdParty
            }
        }

        public func encode(to encoder: Encoder) throws {
            try underlyingObject.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(Kind.self, forKey: .type)
            
            switch type {
            case .firstParty:
                self = .firstParty(try FirstPartyModule.Output(from: decoder))

            case .thirdParty:
                self = .thirdParty(try ThirdPartyModule.Output(from: decoder))
            }
        }
    }
}

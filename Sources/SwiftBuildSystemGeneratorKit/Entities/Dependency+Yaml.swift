import Foundation
import Path

extension Dependency {
    public enum Yaml: Codable {
        case firstParty(Path)
        case thirdParty(String)

        public var type: Kind {
            switch self {
            case .firstParty:
                return .firstParty

            case .thirdParty:
                return .thirdParty
            }
        }

        public enum Kind: String, Codable {
            case firstParty
            case thirdParty
        }

        private enum CodingKeys: String, CodingKey {
            case type
            case path
            case name
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let dep = try? container.decode(FirstParty.self) {
                self = .firstParty(dep.firstParty)
            } else if let dep = try? container.decode(ThirdParty.self) {
                self = .thirdParty(dep.thirdParty)
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "The specified dependency is not supported"
                )
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(type, forKey: .type)
            switch self {
            case let .firstParty(name):
                try container.encode(name, forKey: .name)

            case let .thirdParty(path):
                try container.encode(path, forKey: .path)
            }
        }
    }
}

private extension Dependency.Yaml {
    struct FirstParty: Codable {
        let firstParty: Path
    }

    struct ThirdParty: Codable {
        let thirdParty: String
    }
}

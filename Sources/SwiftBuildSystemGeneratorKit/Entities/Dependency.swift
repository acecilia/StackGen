import Foundation
import AnyCodable

public enum Dependency {
    public enum Middleware {
        case target(Target.Middleware)
        case artifact(Artifact.Output)

        public var name: String {
            switch self {
            case .target(let target):
                return target.name

            case .artifact(let artifact):
                return artifact.name
            }
        }
    }

    public enum Output: Codable {
        case target(Target.Output)
        case artifact(Artifact.Output)

        private enum CodingKeys: String, CodingKey {
            case type
        }

        public enum Kind: String, Codable {
            case target
            case artifact
        }

        public var underlyingObject: DictionaryConvertible {
            switch self {
            case .target(let target):
                return target

            case .artifact(let artifact):
                return artifact
            }
        }

        public var type: Kind {
            switch self {
            case .target:
                return .target

            case .artifact:
                return .artifact
            }
        }

        public func encode(to encoder: Encoder) throws {
            let basePath = encoder.userInfo[.relativePath] as! Path
            var dict = try underlyingObject.asDictionary(basePath)
            dict[CodingKeys.type.rawValue] = type.rawValue

            var container = encoder.singleValueContainer()
            try container.encode(dict.mapValues { AnyCodable($0) })
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(Kind.self, forKey: .type)
            
            switch type {
            case .target:
                self = .target(try Target.Output(from: decoder))

            case .artifact:
                self = .artifact(try Artifact.Output(from: decoder))
            }
        }
    }
}

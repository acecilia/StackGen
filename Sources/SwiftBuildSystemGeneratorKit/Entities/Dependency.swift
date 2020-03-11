import Foundation
import AnyCodable

enum Dependency {
    enum Middleware {
        case target(Target.Middleware)
        case artifact(Artifact.Output)

        var name: String {
            switch self {
            case .target(let target):
                return target.name

            case .artifact(let artifact):
                return artifact.name
            }
        }
    }

    enum Output: Encodable {
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
            var dict = try underlyingObject.asDictionary(basePath: basePath)
            dict[CodingKeys.type.rawValue] = type.rawValue

            var container = encoder.singleValueContainer()
            try container.encode(dict.mapValues { AnyCodable($0) })
        }
    }
}

import Foundation
import Path

extension Dependency {
    public enum Yaml: Codable {
        case module(Path)
        case framework(String)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let dep = try? container.decode(Module.self) {
                self = .module(dep.module)
            } else if let dep = try? container.decode(Framework.self) {
                self = .framework(dep.framework)
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "The specified dependency is not supported"
                )
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case let .module(path):
                try container.encode(Module(module: path))

            case let .framework(name):
                try container.encode(Framework(framework: name))
            }
        }
    }
}

private extension Dependency.Yaml {
    struct Module: Codable {
        let module: Path
    }

    struct Framework: Codable {
        let framework: String
    }
}

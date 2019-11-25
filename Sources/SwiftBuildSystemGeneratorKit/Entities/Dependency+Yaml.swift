import Foundation
import Path

extension Dependency {
    public enum Yaml: Decodable {
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

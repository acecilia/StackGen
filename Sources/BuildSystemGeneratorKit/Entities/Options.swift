import Foundation
import Path

public enum Options {
    public struct CLI: Codable {
        public let templates: String?

        public init(templates: String? = nil) {
            self.templates = templates
        }
    }

    public struct BsgFile: Codable {
        public let templates: String?
        public let topLevel: String?

        public init(
            templates: String? = nil,
            topLevel: String? = nil
        ) {
            self.templates = templates
            self.topLevel = topLevel
        }
    }

    public struct Resolved {
        public let templates: String

        public static func resolve(_ cliOptions: CLI, _ bsgFileOptions: BsgFile) throws -> Resolved {
            if let topLevel = bsgFileOptions.topLevel {
                cwd = Path(topLevel) ?? Path(Path.cwd)/topLevel
            } else {
                cwd = Path(Path.cwd)
            }

            return Resolved(
                templates: try (cliOptions.templates ?? bsgFileOptions.templates)
                    .unwrap(onFailure: .requiredParameterNotFound(name: "templateFile"))
            )
        }
    }
}

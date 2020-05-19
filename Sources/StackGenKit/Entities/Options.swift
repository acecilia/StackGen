import Foundation
import Path

public enum Options {
    /// The options that the tool accepts through the command line
    public struct CLI: Codable {
        public let templates: String?

        public init(templates: String? = nil) {
            self.templates = templates
        }
    }

    /// The options that the tool accepts through the stackgen.yml file
    public struct StackGenFile: Codable {
        /// The templates identification to be used
        public let templates: String?
        /// A custom repository root to be used, if it is not the cwd
        public let root: String?

        public init(
            templates: String? = nil,
            root: String? = nil
        ) {
            self.templates = templates
            self.root = root
        }
    }

    /// The final options to be used during execution
    public struct Resolved {
        public let templates: String

        public init(_ cliOptions: CLI, _ stackGenFileOptions: StackGenFile) throws  {
            self.templates = try (cliOptions.templates ?? stackGenFileOptions.templates)
                .unwrap(onFailure: .requiredParameterNotFound(name: "templateFile"))
        }
    }
}

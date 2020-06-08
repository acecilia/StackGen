import Foundation
import Path

/// A namespace grouping the options passed to the tool
public enum Options {
    /// The options that the tool accepts through the command line
    public struct CLI: Codable {
        /// The template groups to use
        public let templateGroups: [String]

        public init(templateGroups: [String]?) {
            self.templateGroups = templateGroups ?? []
        }
    }

    /// The options that the tool accepts through the stackgen.yml file
    public struct StackGenFile: AutoCodable {
        public static let defaultTemplateGroups: [String] = []
        public static let defaultChecks: Checks = .init()

        /// The version of StackGen to be used with this stackgen.yml file
        public let version: String
        /// The template groups to use
        public let templateGroups: [String]
        /// A custom repository root to be used, if it is not the cwd
        public let root: String?
        /// The checks to perform when executing the tool
        public let checks: Checks

        public init(
            version: String = Constant.version,
            templateGroups: [String] = defaultTemplateGroups,
            root: String? = nil,
            checks: Checks = defaultChecks
        ) {
            self.version = version
            self.templateGroups = templateGroups
            self.root = root
            self.checks = checks
        }
    }

    /// The final options to be used during execution
    public struct Resolved {
        /// The template groups to use
        public let templateGroups: [String]

        public init(_ cliOptions: CLI, _ stackgenFileOptions: StackGenFile) throws  {
            self.templateGroups = try [cliOptions.templateGroups, stackgenFileOptions.templateGroups]
                .first { $0.isEmpty == false }
                .unwrap(onFailure: .requiredParameterNotFound(name: "templateGroups"))
        }
    }
}

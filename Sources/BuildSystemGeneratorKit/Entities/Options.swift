import Foundation
import Path

public enum Options {
    public struct Input: Codable {
        public let templatesPath: String?

        public init(templatesPath: String? = nil) {
            self.templatesPath = templatesPath
        }

        public func resolve(using cliOptions: Options.Input) throws -> Resolved {
            return Resolved(
                templatesPath: try (cliOptions.templatesPath ?? self.templatesPath).require(parameter: "templatesPath")
            )
        }
    }

    public struct Resolved {
        public let templatesPath: String
    }
}

private extension Optional {
    func require(parameter: String) throws -> Wrapped {
        guard let unwrapped = self else {
            throw CustomError(.requiredParameterNotFound(name: parameter))
        }
        return unwrapped
    }
}

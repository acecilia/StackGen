import Foundation
import Path

public enum Options {
    public struct Input: Codable {
        public let templatesFile: Path?

        public init(templatesFile: Path? = nil) {
            self.templatesFile = templatesFile
        }

        public func resolve(using cliOptions: Options.Input) throws -> Resolved {
            return Resolved(
                templatesFile: try (cliOptions.templatesFile ?? self.templatesFile).require(parameter: "templatesFile")
            )
        }
    }

    public struct Resolved {
        public let templatesFile: Path
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

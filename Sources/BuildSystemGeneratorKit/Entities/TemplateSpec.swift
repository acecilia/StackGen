import Foundation
import Path

public struct TemplateSpec: Decodable {
    public static let fileName = "templates.yml"
    public static let defaultFolderName = "Templates"

    public let mode: Mode

    public static func selectTemplate(_ relativePath: String) throws -> Path {
        let paths: [Path?] = [
            // First: treat as absolut path
            Path(relativePath),
            // Second: check relative to the current location
            cwd/relativePath,
            // Third: check the bundled templates. They should be located next to the binary (follow symlinks if needed)
            try? Bundle.main.executable?.readlink().parent.join(TemplateSpec.defaultFolderName).join(relativePath),
            // Fourth: check the path relative to this file (to be used during development)
            Path(#file)?.parent.parent.parent.parent.join(TemplateSpec.defaultFolderName).join(relativePath)
            ]

        return try paths
            .compactMap { $0 }
            .map { $0/TemplateSpec.fileName }
            .first { $0.exists }
            .require(relativePath)
    }
}

private extension Optional {
    func require(_ relativePath: String) throws -> Wrapped {
        guard let unwrapped = self else {
            throw CustomError(.templateNotFound(relativePath: relativePath))
        }
        return unwrapped
    }
}

public extension TemplateSpec {
    enum Mode: Decodable {
        public static let defaultModuleFilter = NSRegularExpression(".*")

        case module(filter: NSRegularExpression)
        case moduleToRoot(filter: NSRegularExpression)
        case root

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let singleValue = try? container.decode(SingleValue.self) {
                switch singleValue {
                case .module:
                    self = .module(filter: Self.defaultModuleFilter)

                case .moduleToRoot:
                    self = .moduleToRoot(filter: Self.defaultModuleFilter)

                case .root:
                    self = .root
                }
            } else {
                let fullValue = try container.decode(FullValue.self)
                switch fullValue {
                case let .module(filter):
                    self = .module(filter: filter?.wrappedValue ?? Self.defaultModuleFilter)

                case let .moduleToRoot(filter):
                    self = .moduleToRoot(filter: filter?.wrappedValue ?? Self.defaultModuleFilter)

                case .root:
                    self = .root
                }

            }
        }
    }
}

extension TemplateSpec.Mode {
    enum SingleValue: String, Codable {
        case module
        case moduleToRoot
        case root
    }

    enum FullValue: AutoCodable {
        case module(filter: RegularExpression?)
        case moduleToRoot(filter: RegularExpression?)
        case root
    }
}

import Foundation
import Path

public struct Globals: Codable, DictionaryConvertible {
    public let bundleIdPrefix: String
    public let supportPath: String
    public let fileName: String
    public let templatesPath: Path
    public let generateXcodeProject: Bool

    public init(yaml: Yaml, path: Path) throws {
        self.bundleIdPrefix = try yaml.bundleIdPrefix.unwrap(onFailure: "A bundleIdPrefix is needed")
        self.supportPath = yaml.supportPath ?? "SupportingFiles"
        self.fileName = yaml.fileName ?? "module.yml"
        self.templatesPath = yaml.templatesPath ?? path/"Templates"
        self.generateXcodeProject = yaml.generateXcodeProject ?? false
    }
}

extension Globals {
    public struct Yaml: Codable {
        public let bundleIdPrefix: String?
        public let supportPath: String?
        public let fileName: String?
        public let templatesPath: Path?
        public let generateXcodeProject: Bool?
    }
}

public extension Optional where Wrapped == Globals {
    func resolve() -> Globals {
        fatalError("TODO")
    }
}

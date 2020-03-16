import Foundation

public enum Target {
    public struct Middleware {
        public let name: String
        public let path: Path
        public let dependencies: [String: [String]]
    }

    public struct Output: Codable, DictionaryConvertible {
        public let name: String
        public let path: Path
        public let subpaths: [Path]
        public let dependencies: [String: [Dependency.Output]]
    }
}



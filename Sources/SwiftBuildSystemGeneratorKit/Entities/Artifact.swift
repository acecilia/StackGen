import Foundation

public struct Artifact {
    public struct Input: Decodable {
        public let regex: String
        public let paths: [Path]
    }

    public struct Middleware {
        public let name: String
        public let path: Path
    }

    public struct Output: Codable, DictionaryConvertible {
        public let name: String
        public let path: Path
        public let version: Version
    }
}

import Foundation

public struct Artifact: Encodable, DictionaryConvertible {
    struct Input: Decodable {
        let regex: String
        let paths: [Path]
    }

    struct Middleware {
        public let name: String
        public let path: Path
    }

    struct Output: Encodable, DictionaryConvertible {
        public let name: String
        public let path: Path
        public let version: Version
    }
}

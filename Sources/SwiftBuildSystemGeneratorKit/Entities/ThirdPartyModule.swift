import Foundation

public struct ThirdPartyModule {
    public struct Output: Codable, Hashable, DictionaryConvertible {
        public let source: Path
        public let sourceParent: Path
        public let name: String
        public let version: Version
    }
}

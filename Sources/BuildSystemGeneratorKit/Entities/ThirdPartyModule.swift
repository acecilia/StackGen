import Foundation
import Path
import Version

public struct ThirdPartyModule {
    public struct Output: Codable, Hashable {
        public let source: Path
        public let sourceParent: Path
        public let name: String
        public let version: Version
    }
}

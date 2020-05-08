import Foundation
import Path
import Version

public struct ThirdPartyModule {
    public struct Output: Codable, Hashable {
        public let source: Path.Output
        public let name: String
        public let version: Version
        public let kind: Dependency.Output.Kind = .thirdParty
    }
}

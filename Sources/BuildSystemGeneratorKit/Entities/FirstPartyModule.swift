import Foundation
import Path

public enum FirstPartyModule {
    public struct Input: AutoCodable {
        public static let defaultDependencies: [String: [String]] = [:]

        public let name: String
        public let dependencies: [String: [String]]
    }

    public struct Middleware {
        public let name: String
        public let path: Path
        public let dependencies: [String: [String]]
    }

    public struct Output: Codable, Hashable {
        public let name: String
        public let path: Path
        public let subpaths: [Path]
        public let dependencies: [String: [Dependency.Output]]
        public let transitiveDependencies: [String: [Dependency.Output]]
    }

    // public typealias Output = Cucu<OutputStruct>
}

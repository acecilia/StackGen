import Foundation
import Path

extension Module {
    public struct Yaml: Codable {
        public let version: String?
        public let dependencies: [Dependency.Yaml]?

        public init() {
            self.version = nil
            self.dependencies = nil
        }
    }
}




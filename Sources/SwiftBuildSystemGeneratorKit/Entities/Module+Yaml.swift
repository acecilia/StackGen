import Foundation
import Path
import Version

extension Module {
    public struct Yaml: Decodable {
        public let version: Version?
        public let dependencies: [Dependency.Yaml]?

        public init() {
            self.version = nil
            self.dependencies = nil
        }
    }
}




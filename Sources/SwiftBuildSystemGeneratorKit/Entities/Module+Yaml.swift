import Foundation
import Path
import Version

extension Module {
    public struct Yaml: Codable {
        public var version: Version?
        public var dependencies: [Dependency.Yaml]?

        public init(
            version: Version? = nil,
            dependencies: [Dependency.Yaml]? = nil
        ) {
            self.version = version
            self.dependencies = dependencies
        }
    }
}




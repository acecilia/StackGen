import Foundation
import Path
import Version

extension Module {
    public struct Yaml: Codable {
        public var version: Version?
        public var dependencies: [Dependency.Yaml]?
        public var testDependencies: [Dependency.Yaml]?

        public init(
            version: Version?,
            dependencies: [Dependency.Yaml]?,
            testDependencies: [Dependency.Yaml]?
        ) {
            self.version = version
            self.dependencies = dependencies?.isEmpty == true ? nil : dependencies
            self.testDependencies = testDependencies?.isEmpty == true ? nil : testDependencies
        }

        public init() {
            self.init(
                version: nil,
                dependencies: nil,
                testDependencies: nil
            )
        }
    }
}




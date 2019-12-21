import Foundation
import Path
import Version

extension Module {
    public struct Yaml: Codable {
        public var dependencies: [String]?
        public var testDependencies: [String]?

        public init(
            dependencies: [String]? = nil,
            testDependencies: [String]? = nil
        ) {
            self.dependencies = dependencies?.somethingOrNil()
            self.testDependencies = testDependencies?.somethingOrNil()
        }
    }
}


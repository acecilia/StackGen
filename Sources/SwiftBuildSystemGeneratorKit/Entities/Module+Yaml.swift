import Foundation
import Path
import Version

extension Module {
    public struct Yaml: Codable {
        public var dependencies: [String]?
        public var testDependencies: [String]?

        public init(
            dependencies: [String]?,
            testDependencies: [String]?
        ) {
            self.dependencies = dependencies?.isEmpty == true ? nil : dependencies
            self.testDependencies = testDependencies?.isEmpty == true ? nil : testDependencies
        }

        public init() {
            self.init(
                dependencies: nil,
                testDependencies: nil
            )
        }
    }
}




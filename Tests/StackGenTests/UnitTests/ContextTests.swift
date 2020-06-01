import XCTest
import Yams
import StackGenKit
import Path

final class ContextTests: XCTestCase {
    func testContext() throws {
        let contextString = """
        env:
          output:
            basename: outputBasename
            parent: outputParent
            path: outputParent/outputBasename
          root:
            basename: rootBasename
            parent: rootParent
            path: rootParent/rootBasename
        global:
          aGlobalVariable: something
          anotherGlobalVariable: somethingElse
        module:
          dependencies:
            main:
            - FileKit
            - Module2
          location:
            basename: Module1
            parent: parentModule1
            path: parentModule1/Module1
          name: Module1
          transitiveDependencies:
            main:
            - FileKit
            - Module2
        modules:
        - dependencies: {}
          kind: firstParty
          location:
            basename: Module1Basename
            parent: Module1Parent
            path: Module1Parent/Module1Basename
          name: Module1
          transitiveDependencies: {}
        - kind: thirdParty
          name: FileKit

        """
        do {
            let userInfo = [CodingUserInfoKey.relativePath: Path.cwd]

            let decoder = YAMLDecoder()
            let decoded = try decoder.decode(Context.Output.self, from: contextString, userInfo: userInfo)

            let encoder = YAMLEncoder()
            encoder.options = YAMLEncoder.Options(sortKeys: true)
            let encoded = try encoder.encode(decoded, userInfo: userInfo)

            XCTAssertEqual(contextString, encoded)
        } catch {
            print(error)
            throw error
        }
    }
}

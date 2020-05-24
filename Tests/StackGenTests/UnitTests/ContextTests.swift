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
        firstPartyModules:
        - Module1
        - Module2
        - Module3
        global:
          aGlobalVariable: something
          anotherGlobalVariable: somethingElse
        module:
          dependencies:
            main:
            - FileKit
            - Module2
          kind: firstParty
          location:
            basename: Module1
            parent: parentModule1
            path: parentModule1/Module1
          name: Module1
          transitiveDependencies:
            main:
            - FileKit
            - Module2
        thirdPartyModules:
        - FileKit

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

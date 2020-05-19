import XCTest
import Yams
import StackGenKit
import Path

final class ContextTests: XCTestCase {
    func xtestContext() throws {
        let contextString = """
        custom:
          aGlobalVariable: something
          anotherGlobalVariable: somethingElse
        firstPartyModules:
        - dependencies:
            main:
            - kind: thirdParty
              name: FileKit
              source: ../Cartfile
              sourceParent: ..
              version: 0.0.1
            - dependencies: {}
              kind: firstParty
              name: Module2
              path: some/path/Module2
              transitiveDependencies: {}
            - dependencies: {}
              kind: firstParty
              name: Module3
              path: some/path/Module3
              transitiveDependencies: {}
          kind: firstParty
          name: Module1
          path: some/path/Module1
          transitiveDependencies: {}
        - dependencies: {}
          kind: firstParty
          name: Module2
          path: some/path/Module2
          transitiveDependencies: {}
        - dependencies: {}
          kind: firstParty
          name: Module3
          path: some/path/Module3
          transitiveDependencies: {}
        global:
          fileName: someFileName
          parent: somePath
          root: ..
          rootBasename: something
        thirdPartyModules:
        - kind: thirdParty
          name: FileKit
          source: ../Cartfile
          sourceParent: ..
          version: 0.0.1

        """
        do {
            let userInfo = [CodingUserInfoKey.relativePath: Path.cwd]

            let decoder = YAMLDecoder()
            let decoded = try decoder.decode(Context.self, from: contextString, userInfo: userInfo)

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

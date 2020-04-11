import XCTest
import Yams
import BuildSystemGeneratorKit
import Path

final class ContextTests: XCTestCase {
    func testContext() throws {
        let contextString = """
        custom:
          aGlobalVariable: something
          anotherGlobalVariable: somethingElse
        firstPartyModules:
        - dependencies:
            main:
            - name: FileKit
              source: ../Cartfile
              sourceParent: ..
              type: thirdParty
              version: 0.0.1
            - dependencies: {}
              name: Module2
              path: some/path/Module2
              subpaths:
              - src/swift
              transitiveDependencies: {}
              type: firstParty
            - dependencies: {}
              name: Module3
              path: some/path/Module3
              subpaths:
              - src/swift
              transitiveDependencies: {}
              type: firstParty
          name: Module1
          path: some/path/Module1
          subpaths:
          - src/swift
          transitiveDependencies: {}
        - dependencies: {}
          name: Module2
          path: some/path/Module2
          subpaths:
          - src/swift
          transitiveDependencies: {}
        - dependencies: {}
          name: Module3
          path: some/path/Module3
          subpaths:
          - src/swift
          transitiveDependencies: {}
        global:
          fileName: someFileName
          parent: somePath
          root: ..
          rootBasename: something
          templatesPath: ../Templates
        thirdPartyModules:
        - name: FileKit
          source: ../Cartfile
          sourceParent: ..
          version: 0.0.1

        """
        do {
            let userInfo = [CodingUserInfoKey.relativePath: cwd]

            let decoder = YAMLDecoder()
            let decoded = try decoder.decode(MainContext.self, from: contextString, userInfo: userInfo)

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

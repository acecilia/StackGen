import XCTest
import Yams
import SwiftBuildSystemGeneratorKit
import Path

final class Tests: XCTestCase {
    func testGenerate() throws {
        for templatesPath in templatesPath.ls().directories {
            let result = try generate(using: templatesPath)
            XCTAssertEqual(result.exitCode, 0)
            assert(fixture: fixturesPath/templatesPath.basename(), equals: result.destination)
        }
    }

    func testContext() throws {
        let contextString = """
        artifacts:
        - name: FileKit
          source: ../Cartfile
          sourceParent: ..
          version: 0.0.1
        global:
          aGlobalVariable: something
          anotherGlobalVariable: somethingElse
          ignore: 5
        modules:
        - dependencies:
            main:
            - name: FileKit
              source: ../Cartfile
              sourceParent: ..
              type: artifact
              version: 0.0.1
            - dependencies: {}
              name: Module2
              path: some/path/Module2
              subpaths:
              - src/swift
              type: target
            - dependencies: {}
              name: Module3
              path: some/path/Module3
              subpaths:
              - src/swift
              type: target
          name: Module1
          path: some/path/Module1
          subpaths:
          - src/swift
        - dependencies: {}
          name: Module2
          path: some/path/Module2
          subpaths:
          - src/swift
        - dependencies: {}
          name: Module3
          path: some/path/Module3
          subpaths:
          - src/swift

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

import XCTest
import StackGenKit
import Path
import RuntimeTestCase

// Integration tests take a lot of time, and my be disabled on CI using this flag
#if DISABLE_INTEGRATION_TESTS
typealias IntegrationTestCase = XCTest
#else
typealias IntegrationTestCase = XCTestCase
#endif

final class IntegrationTests: IntegrationTestCase {
    static func testSpecs() -> [RuntimeTestCaseSpec<IntegrationTests>] {
        return Template.Swift_BuildSystem.map { template in
            RuntimeTestCaseSpec(template.rawValue) { testCase in
                try testCase.swift_BuildSystem_Tests(template)
            }
        }
    }

    func swift_BuildSystem_Tests(_ template: Template) throws {
        try assertGenerate(template)
        assertSetup()
        assertTest()
        // Archiving requires a provisioning profile on CI, which is not setup yet
        // assertArchive()
        assertLefthook()
    }

    func test_Swift_Starter_CommandLine() throws {
        try assertGenerate(.Swift_Starter_CommandLine)
        try assertSPMBuild()
    }
}

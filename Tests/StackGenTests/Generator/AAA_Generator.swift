import XCTest
import StackGenCLI
import StackGenKit
import Path
import Foundation

// This tests are used to regenerate the fixtures and other files. They are enabled by default, but disabled on CI
#if DISABLE_GENERATOR
typealias GeneratorTestCase = XCTest
#else
typealias GeneratorTestCase = XCTestCase
#endif

final class AAA_Generator: GeneratorTestCase {
    func test_01_Clean() throws {
        // It is faster to move the files than to remove them
        let trash = Path(NSTemporaryDirectory())!/"StackGen"/UUID().uuidString
        if fixturesPath.exists { try fixturesPath.move(into: trash) }
        if testsOutputPath.exists { try testsOutputPath.move(into: trash) }
    }

    func test_02_SelfGenerate() throws {
        let path = rootPath
        FileManager.default.changeCurrentDirectoryPath(path.string)

        let cli = CLI()
        let exitCode = cli.execute(with: [Generate.name])
        XCTAssertEqual(exitCode, 0)
    }

    func test_03_GenerateFixtures() throws {
        Snapshot.recording = true
        for testSpec in GenerateTests.testSpecs() {
            let test = GenerateTests()
            try testSpec.implementation(test)
        }
        Snapshot.recording = false
    }

    func test_04_GenerateSwiftRuntime() throws {
        let files = [
            rootPath/"Sources/StackGenKit/Entities/Context.swift",
            rootPath/"Sources/StackGenKit/Entities/FirstPartyModule.swift",
            rootPath/"Sources/StackGenKit/Entities/ThirdPartyModule.swift",
            rootPath/"Sources/StackGenKit/Entities/ModuleKind.swift",
            rootPath/"Sources/StackGenKit/Entities/Path+Output.swift",
            rootPath/"Sources/StackGenKit/Sourcery/AutoCodable.swift",
        ]
        var output: [String] = []
        output.append("""
            import SwiftTemplateEngine

            let stackgenRuntimeFiles: [SwiftTemplate.File] = [
            """
        )
        for file in files {
            let content = try String(contentsOf: file)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let string = """
                .init(
                    name: "\(file.basename())",
                    content: \"""
            \(content)
            \"""
                ),
            """
            output.append(string)
        }
        output.append("]")

        let outputPath = rootPath/"Sources"/"StackGenKit"/"Generated"/"Runtime.generated.swift"
        try output
            .joined(separator: "\n")
            .write(to: outputPath)
    }
}

import Foundation
import BuildSystemGeneratorCLI
import BuildSystemGeneratorKit
import Path

let rootPath = Path(#file)!/".."/".."/".."/".."
let testsOutputPath = rootPath/"TestsOutput"
let templatesPath = rootPath/"Templates"
let carthagePath = examplesPath/"Carthage"/"Build"/"iOS"

let examplesPath = rootPath/"Examples"/"swift"
let fixturesPath = rootPath/"Fixtures"

func tmp(_ testFilePath: String, _ testName: String, _ templateName: String) throws -> Path {
    guard let testFileName = Path(testFilePath)?.basename(dropExtension: true) else {
        fatalError("The path to the test file is malformed")
    }
    let testOutputPath = testsOutputPath/testFileName/functionName(testName)/templateName
    try testOutputPath.mkdir(.p)
    let testFolders = testOutputPath.ls().directories.sorted()
    let testIndex: Int
    if let lastTestIndex = testFolders.compactMap({ Int($0.basename()) }).max() {
        testIndex = lastTestIndex + 1
    } else {
        testIndex = 0
    }
    return testOutputPath/"\(testIndex)"
}

func functionName(_ methodSignature: String) -> String {
    return methodSignature
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
}

func patchBsgFile(_ path: Path, using templatesPath: Path) throws {
    let bsgFilePath = path/BsgFile.fileName
    let content = try String(contentsOf: bsgFilePath)
        // Below line is not needed for now, as the Carthage directory gets also copied over when running tests
        // .replacingOccurrences(of: "Cartfile", with: "\((examplesPath/"Cartfile").relative(to: cwd))")
        .replacingOccurrences(of: "../../templates/xcodegen", with: templatesPath.relative(to: cwd))
    try bsgFilePath.delete()
    try content.write(to: bsgFilePath)
}

func generate(using templatesPath: Path, testFilePath: String = #file, function: String = #function) throws -> (destination: Path, exitCode: Int32) {
    let destination = try examplesPath.copy(into: try tmp(testFilePath, function, templatesPath.basename()))
    FileManager.default.changeCurrentDirectoryPath(destination.string)
    try patchBsgFile(destination, using: templatesPath)

    let cli = BuildSystemGeneratorCLI()
    let exitCode = cli.execute(with: [GenerateCommand.name])

    return (destination: destination, exitCode: exitCode)
}

func clean() -> Int32 {
    let cli = BuildSystemGeneratorCLI()
    return cli.execute(with: [CleanCommand.name])
}


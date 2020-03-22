import Foundation
import BuildSystemGeneratorCLI
import BuildSystemGeneratorKit
import Path

let rootPath = Path(#file)!/".."/".."/".."/".."
let testsOutputPath = rootPath/".build"/"TestsOutput"
let templatesPath = rootPath/"Templates"
let carthagePath = examplesPath/"Carthage"/"Build"/"iOS"

let examplesPath = rootPath/"Examples"/"swift"
let fixturesPath = rootPath/"Fixtures"

func tmp(testFilePath: String = #file, testName: String = #function) throws -> Path {
    guard let testFileName = Path(testFilePath)?.basename(dropExtension: true) else {
        fatalError("The path to the test file is malformed")
    }
    let testOutputPath = testsOutputPath/testFileName/functionName(testName)
    let testFolders = testOutputPath.ls()
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

func patchWorkspaceFile(_ path: Path, using templatesPath: Path) throws {
    let workspaceFilePath = path/"bsg.yml"
    let content = try String(contentsOf: workspaceFilePath)
        .replacingOccurrences(of: "Cartfile", with: "\((examplesPath/"Cartfile").relative(to: cwd))")
        .replacingOccurrences(of: "../../templates/xcodegen", with: templatesPath.relative(to: cwd))
    try workspaceFilePath.delete()
    try content.write(to: workspaceFilePath)
}

func generate(using templatesPath: Path, testFilePath: String = #file, function: String = #function) throws -> (destination: Path, exitCode: Int32) {
    let destination = try examplesPath.copy(into: try tmp(testFilePath: testFilePath, testName: function))
    FileManager.default.changeCurrentDirectoryPath(destination.string)
    try patchWorkspaceFile(destination, using: templatesPath)

    let cli = BuildSystemGeneratorCLI()
    let exitCode = cli.execute(with: [GenerateCommand.name])

    return (destination: destination, exitCode: exitCode)
}

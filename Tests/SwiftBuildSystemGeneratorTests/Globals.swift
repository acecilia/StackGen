import Foundation
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

let rootPath = Path(#file)!/".."/".."/".."
let testsOutputPath = rootPath/".build"/"TestsOutput"
let templatesPath = rootPath/"Templates"
let carthagePath = rootPath/"Carthage"/"Build"/"iOS"

let examplesPath = rootPath/"Examples"
let fixturesPath = rootPath/"Fixtures"
//
//let generatorFixturesPath = fixturesPath/"\(Generator.self)"
//let converterFixturesPath = fixturesPath/"\(Converter.self)"
//
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

func generateCommandArgs() -> [String] {
    return [GenerateCommand.name]
}

func patchWorkspaceFile(_ path: Path, using templatesPath: Path) throws {
    let workspaceFilePath = path/"workspace.yml"
    let content = try String(contentsOf: workspaceFilePath)
        .replacingOccurrences(of: "../Carthage/Build/iOS", with: carthagePath.string)
        .replacingOccurrences(of: "../templates/xcodegen", with: templatesPath.string)
    try workspaceFilePath.delete()
    try content.write(to: workspaceFilePath)
}

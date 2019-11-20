import Foundation
import SwiftBuildSystemGeneratorCLI
import Path

let rootPath = Path(#file)!/".."/".."/".."
let testsOutputPath = rootPath/".build"/"TestsOutput"

let examplesPath = rootPath/"Examples"
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

let generateCommandArgs = [GenerateCommand.name]


import Foundation
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

let rootPath = Path(#file)!/".."/".."/".."
let testsOutputPath = rootPath/".build"/"TestsOutput"

let examplesPath = rootPath/"Examples"
let fixturesPath = rootPath/"Fixtures"

let generatorFixturesPath = fixturesPath/"\(Generator.self)"
let converterFixturesPath = fixturesPath/"\(Converter.self)"

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

func generateCommandArgs(_ generator: Generator) -> [String] {
    return [
        GenerateCommand.name,
        "-x",
        "-t", "\((rootPath/"Templates").string)",
        "-g", "\(generator.rawValue)",
        "-r", rootPath.relative(to: Path.cwd)
    ]
}

func cleanCommandArgs(generator: Generator? = nil, converter: Converter? = nil) -> [String] {
    var args = [
        CleanCommand.name,
        "-r", rootPath.relative(to: Path.cwd)
    ]

    if let generator = generator {
        args.append(contentsOf: [
            "-g", "\(generator.rawValue)"
        ])
    }

    if let converter = converter {
        args.append(contentsOf: [
            "-c", "\(converter.rawValue)"
        ])
    }

    return args
}

func convertCommandArgs(_ converter: Converter) -> [String] {
    return [
        ConvertCommand.name,
        "-c", "\(converter.rawValue)"
    ]
}

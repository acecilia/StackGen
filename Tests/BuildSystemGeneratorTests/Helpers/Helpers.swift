import Foundation
import BuildSystemGeneratorCLI
import BuildSystemGeneratorKit
import Path

let rootPath = Path(#file)!/".."/".."/".."/".."
let testsOutputPath = rootPath/".testsOutput"
let templatesPath = rootPath/"Templates"

let carthagePath = examplesPath/"Carthage"/"Build"/"iOS"

let examplesPath = rootPath/"Examples"/"swift"
let fixturesPath = rootPath/".fixtures"

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

    let finaltestOutputPath = testOutputPath/"\(testIndex)"
    try finaltestOutputPath.mkdir(.p)
    return finaltestOutputPath
}

func functionName(_ methodSignature: String) -> String {
    return methodSignature
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
}

func patchBsgFile(at path: Path, using templatesPath: Path) throws {
    let bsgFilePath = path/BsgFile.fileName
    let content = try String(contentsOf: bsgFilePath)
        .replacingOccurrences(of: "../YourTemplateFolder", with: templatesPath.relative(to: path))
    try bsgFilePath.delete()
    try content.write(to: bsgFilePath)
}

func generate(using template: Template, testFilePath: String = #file, function: String = #function) throws -> (destination: Path, exitCode: Int32) {
    let destination = try tmp(testFilePath, function, template.rawValue)

    if let prefillingPath = template.prefillPath {
        try destination.delete()
        try prefillingPath.copy(to: destination)
        try patchBsgFile(at: destination, using: template.path)
    }

    FileManager.default.changeCurrentDirectoryPath(destination.string)

    let cli = BuildSystemGeneratorCLI()
    let exitCode = cli.execute(with: [GenerateCommand.name])

    return (destination: destination, exitCode: exitCode)
}

func clean() -> Int32 {
    let cli = BuildSystemGeneratorCLI()
    return cli.execute(with: [CleanCommand.name])
}


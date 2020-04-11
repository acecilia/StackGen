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
    try testOutputPath.delete()
    try testOutputPath.mkdir(.p)
    return testOutputPath
}

func functionName(_ methodSignature: String) -> String {
    return methodSignature
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
}

func patchBsgFile(at bsgFilePath: Path, using templatesPath: Path) throws {
    let content = try String(contentsOf: bsgFilePath)
        .replacingOccurrences(of: "../YourTemplateFolder", with: templatesPath.relative(to: bsgFilePath.parent))
    try bsgFilePath.delete()
    try content.write(to: bsgFilePath)
}

func generate(using template: Template, testFilePath: String = #file, function: String = #function) throws -> (destination: Path, exitCode: Int32) {
    let destination = try tmp(testFilePath, function, template.rawValue)

    if let prefillingPath = template.prefillPath {
        try destination.delete()
        try prefillingPath.copy(to: destination)
    }

    let generateCmd: [String]

    let bsgFilePath = destination/BsgFile.fileName
    if bsgFilePath.exists {
        try patchBsgFile(at: bsgFilePath, using: template.path)
        generateCmd = [Generate.name]
    } else {
        generateCmd = [Generate.name, "-t", template.path.string]
    }

    FileManager.default.changeCurrentDirectoryPath(destination.string)

    let cli = CLI()
    let exitCode = cli.execute(with: generateCmd)

    return (destination: destination, exitCode: exitCode)
}

func clean() -> Int32 {
    let cli = CLI()
    return cli.execute(with: [Clean.name])
}


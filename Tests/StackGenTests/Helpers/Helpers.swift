import Foundation
import StackGenCLI
import StackGenKit
import Path

let rootPath = Path(#file)!/".."/".."/".."/".."
let examplesPath = rootPath/"Examples"/"swift"
let templatesPath = rootPath/"Templates"
let testsOutputPath = rootPath/".testsOutput"
let fixturesPath = rootPath/".fixtures"

func tmp(
    _ suffix: String,
    _ file: String = #file,
    _ function: String = #function
) throws -> Path {
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    let functionName = function.components(separatedBy: "(")[0]
    let outputPath = testsOutputPath/fileName/functionName/suffix
    try outputPath.delete()
    try outputPath.mkdir(.p)
    return outputPath
}

func patchTemplate(at stackGenFilePath: Path, using template: Template) throws {
    let content = try String(contentsOf: stackGenFilePath)
        .replacingOccurrences(of: "Swift_BuildSystem_Xcodegen", with: template.rawValue)
    try content.write(to: stackGenFilePath)
}

func patchTopLevel(at stackGenFilePath: Path, using root: Path) throws {
    var content = try String(contentsOf: stackGenFilePath)
    content.append("  root: \(root.relative(to: stackGenFilePath.parent))")
    try content.write(to: stackGenFilePath)
}

func prefill(_ destination: Path, using template: Template) throws {
    if let prefillingPath = template.prefillPath {
        try destination.delete()
        try prefillingPath.copy(to: destination)
    }
}

func generate(in destination: Path, using template: Template) throws -> Int32 {
    let generateCmd: [String]

    let stackGenFilePath = destination/StackGenFile.fileName
    if stackGenFilePath.exists {
        try patchTemplate(at: stackGenFilePath, using: template)
        generateCmd = [Generate.name]
    } else {
        generateCmd = [Generate.name, "-t", template.rawValue]
    }

    FileManager.default.changeCurrentDirectoryPath(destination.string)

    let cli = CLI()
    let exitCode = cli.execute(with: generateCmd)

    return exitCode
}

func prefillAndGenerate(
    using template: Template,
    _ file: String = #file,
    _ function: String = #function
) throws -> (destination: Path, exitCode: Int32) {
    let destination = try tmp(template.rawValue, file, function)
    try prefill(destination, using: template)
    let exitCode = try generate(in: destination, using: template)
    return (destination: destination, exitCode: exitCode)
}

func clean(using template: Template) -> Int32 {
    let cli = CLI()

    let cmd: [String]
    let stackGenFilePath = Path.cwd/StackGenFile.fileName
    if stackGenFilePath.exists {
        cmd = [Clean.name]
    } else {
        cmd = [Clean.name, "-t", template.rawValue]
    }

    return cli.execute(with: cmd)
}


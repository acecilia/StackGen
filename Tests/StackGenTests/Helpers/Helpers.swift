import Foundation
import StackGenCLI
import StackGenKit
import Path

let rootPath = Path(#file)!.join("../../../..")
let examplesPath = rootPath.join("Examples/swift")
let templatesPath = rootPath.join("Templates")
let testsOutputPath = rootPath.join(".testsOutput")
let fixturesPath = rootPath.join(".fixtures")

func tmp(
    _ suffix: String,
    _ file: String = #file,
    _ function: String = #function
) throws -> Path {
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    let functionName = function.components(separatedBy: "(")[0]
    let outputPath = testsOutputPath.join(fileName).join(functionName).join(suffix)
    try outputPath.delete()
    try outputPath.mkdir(.p)
    return outputPath
}

func patchTemplate(at stackgenFilePath: Path, using template: Template) throws {
    let content = try String(contentsOf: stackgenFilePath)
        .replacingOccurrences(of: "StackGen_Swift_BuildSystem_Xcodegen", with: template.rawValue)
    try content.write(to: stackgenFilePath)
}

func patchTopLevel(at stackgenFilePath: Path, using root: Path) throws {
    let content = try String(contentsOf: stackgenFilePath)
        .replacingOccurrences(
        of: "options:",
        with: """
        options:
          root: \(root.relative(to: stackgenFilePath.parent))
        """
    )
    try content.write(to: stackgenFilePath)
}

func prefill(_ destination: Path, using template: Template) throws {
    if let prefillingPath = template.prefillPath {
        try destination.delete()
        try prefillingPath.copy(to: destination)
    }
}

func generate(in destination: Path, using template: Template) throws -> Int32 {
    let generateCmd: [String]

    let stackgenFilePath = destination.join(Constant.stackGenFileName)
    if stackgenFilePath.exists {
        try patchTemplate(at: stackgenFilePath, using: template)
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
    let stackgenFilePath = Path.cwd.join(Constant.stackGenFileName)
    if stackgenFilePath.exists {
        cmd = [Clean.name]
    } else {
        cmd = [Clean.name, "-t", template.rawValue]
    }

    return cli.execute(with: cmd)
}


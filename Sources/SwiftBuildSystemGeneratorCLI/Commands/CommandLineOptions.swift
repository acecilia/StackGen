import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit
import Path

public struct CommandLineOptions {
    static let shared = CommandLineOptions()

    var fileName: Key<String> {
        Key<String>("-f", "--fileName", description: "The file name of the configuration files. Default value is '\(Options.defaultFileName)'")
    }

    var templatesPath: Key<String> {
        Key<String>("-t", "--templates", description: "The path to the folder containing the templates to use. Default value is '\(Options.defaultTemplatesPath)'")
    }

    var generateXcodeProject: Flag {
        Flag("-x", "--generateXcodeProject", description: "In addition to the build files, also generate the Xcode project and workspace. Default value is '\(Options.defaultGenerateXcodeProject)'")
    }

    var generators: VariadicKey<Generator> {
        VariadicKey<Generator>("-g", "--generators", description: "A comma separated list of values specifying which generators to execute. Default value is all of them: '\(Generator.allCases.map { $0.rawValue }.joined(separator: " ,"))'")
    }

    var carthagePath:Key<Path> {
        Key<Path>("-c", "--carthagePath", description: "The path to the folder containing the 'Cartfile'. Default value is the current working directory: \(Options.defaultCarthagePath)")
    }
}


extension Path: ConvertibleFromString {
    public static func convert(from: String) -> Path? {
        return Path.cwd/from
    }
}

extension Generator: ConvertibleFromString { }

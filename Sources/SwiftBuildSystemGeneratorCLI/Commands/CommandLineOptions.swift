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

    var generateXcodeProject: Key<Bool> {
        Key<Bool>("-x", "--generateXcodeProject", description: "In addition to the build files, also generate the Xcode project. Default value is '\(Options.defaultGenerateXcodeProject)'")
    }

    var generateXcodeWorkspace: Key<Bool> {
        Key<Bool>("-w", "--generateXcodeWorkspace", description: "In addition to the build files, also generate the Xcode workspace. Default value is '\(Options.defaultGenerateXcodeWorkspace)'")
    }

    var generators: Key<[Generator]> {
        Key<[Generator]>("-g", "--generators", description: "A comma separated list of values specifying which generators to execute. Default value is all of them: '\(Generator.allCases.map { $0.rawValue }.joined(separator: " ,"))'")
    }

    var converters: Key<[Converter]> {
        Key<[Converter]>("-c", "--converters", description: "A comma separated list of values specifying which converters to execute. Default value is none of them")
    }

    var carthagePath:Key<Path> {
        Key<Path>("-r", "--carthagePath", description: "The path to the folder containing the 'Cartfile'. Default value is the current working directory: \(Options.defaultCarthagePath)")
    }
}


extension Path: ConvertibleFromString {
    public static func convert(from: String) -> Path? {
        return cwd/from
    }
}

extension Array: ConvertibleFromString where Element: RawRepresentable, Element.RawValue == String, Element: CaseIterable {
    public static func convert(from: String) -> Array<Element>? {
        let elements = from.components(separatedBy: ",")
        let castedElements = elements.compactMap { Element.init(rawValue: $0) }
        return castedElements.count == elements.count ? castedElements : nil
    }
}

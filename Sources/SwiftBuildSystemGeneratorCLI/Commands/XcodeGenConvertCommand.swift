import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit

public class XcodeGenConvertCommand: Command {
    public static let name: String = "xcodegen-convert"
    public let shortDescription: String = "Converts 'project.yml' files into 'module.yml'"

    public init() { }

    public func execute() throws {
        try XcodeGenConvertAction().execute()
    }
}

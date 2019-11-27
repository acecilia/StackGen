import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit

public class ConvertCommand: Command {
    public static let name: String = "convert"
    public let shortDescription: String = "Converts build files into 'module.yml'"

    public init() { }

    public func execute() throws {
        try XcodeGenConvertAction().execute()
    }
}

import Foundation
import SwiftCLI
import BuildSystemGeneratorKit
import Path

public class GenerateCommand: Command {
    public static let name: String = "generate"
    public let shortDescription: String = "Generates build system configurations for swift projects"

    public init() { }

    public func execute() throws {
        try GenerateAction().execute()
    }
}

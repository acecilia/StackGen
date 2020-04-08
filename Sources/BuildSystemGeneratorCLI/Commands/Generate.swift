import Foundation
import SwiftCLI
import BuildSystemGeneratorKit

public class Generate: Command {
    public let shortDescription: String = "Generates build system configurations for swift projects"

    public init() { }

    public func execute() throws {
        try GenerateAction().execute()
    }
}

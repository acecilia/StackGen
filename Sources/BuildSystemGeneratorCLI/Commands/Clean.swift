import Foundation
import SwiftCLI
import BuildSystemGeneratorKit

public class Clean: Command {
    public let shortDescription: String = "Remove all previously generated files"

    public init() { }

    public func execute() throws {
        try CleanAction().execute()
    }
}

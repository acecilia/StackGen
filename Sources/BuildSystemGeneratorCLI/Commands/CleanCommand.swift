import Foundation
import SwiftCLI
import BuildSystemGeneratorKit

public class CleanCommand: Command {
    public static let name: String = "clean"
    public let shortDescription: String = "Remove all previously generated files"

    public init() { }

    public func execute() throws {
        try CleanAction().execute()
    }
}

import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit
import Path

public class CleanCommand: Command {
    public static let name: String = "clean"
    public let shortDescription: String = "Removes all generated build system configurations"

    public init() { }

    public func execute() throws {
        try CleanAction().execute()
    }
}

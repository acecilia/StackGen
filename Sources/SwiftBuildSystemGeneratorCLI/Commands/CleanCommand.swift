import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit
import Path

public class CleanCommand: Command {
    public static let name: String = "clean"
    public let shortDescription: String = "Removes all generated build system configurations"

    let reporter: ReporterInterface
    public init(reporter: ReporterInterface) {
        self.reporter = reporter
    }

    public func execute() throws {
        let action = CleanAction(reporter: reporter)
        try action.execute()
    }
}

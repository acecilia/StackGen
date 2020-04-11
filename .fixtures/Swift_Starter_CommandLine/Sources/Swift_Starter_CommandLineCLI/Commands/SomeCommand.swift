import Foundation
import SwiftCLI
import Swift_Starter_CommandLineKit

public class SomeCommand: Command {
    public let shortDescription: String = "SomeCommand description"

    public init() { }

    public func execute() throws {
        try SomeCommandAction().execute()
    }
}

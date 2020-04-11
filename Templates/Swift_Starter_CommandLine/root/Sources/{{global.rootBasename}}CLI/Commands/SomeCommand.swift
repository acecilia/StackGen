import Foundation
import SwiftCLI
import {{global.rootBasename}}Kit

public class SomeCommand: Command {
    public let shortDescription: String = "SomeCommand description"

    public init() { }

    public func execute() throws {
        try SomeCommandAction().execute()
    }
}

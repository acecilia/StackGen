import SwiftCLI

protocol Command: SwiftCLI.Command {
    static var name: String { get }
}

extension Command {
    public var name: String {
        return Self.name
    }
}

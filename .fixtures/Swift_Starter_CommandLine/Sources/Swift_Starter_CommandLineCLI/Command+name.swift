import SwiftCLI

extension Command {
    public static var name: String { "\(Self.self)".lowercased() }

    public var name: String {
        return Self.name
    }
}

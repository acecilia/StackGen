import Foundation

public class DefaultReporter: ReporterInterface {
    private static let prefix = "✨"

    public init() { }

    public func print(_ string: String) {
        Swift.print("\(Self.prefix) \(string)")
    }
}

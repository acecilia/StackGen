import Foundation

// MARK: Dictionary extension. Used to obtain the transitive dependencies

extension Dictionary where Key == String, Value == [String] {
    var main: [String] {
        return self["main"] ?? []
    }
}

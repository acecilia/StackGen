import Foundation

extension Array {
    func sortedAlphabetically(_ keyPath: KeyPath<Element, String>) -> [Element] {
        self.sorted {
            $0[keyPath: keyPath].caseInsensitiveCompare($1[keyPath: keyPath]) == .orderedAscending
        }
    }
}

extension Array where Element == String {
    func sortedAlphabetically() -> [Element] {
        return sortedAlphabetically(\.self)
    }
}

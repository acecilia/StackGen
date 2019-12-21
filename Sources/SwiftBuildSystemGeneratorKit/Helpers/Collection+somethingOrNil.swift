import Foundation

extension Collection {
    func somethingOrNil() -> Self? {
        return self.isEmpty ? nil : self
    }
}

import Foundation

enum Module {
    struct Input: Codable, AutoCodable {
        static let defaultDependencies: [String: [String]] = [:]

        let name: String
        let dependencies: [String: [String]]
    }
}

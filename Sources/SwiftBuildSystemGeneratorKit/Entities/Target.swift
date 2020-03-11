import Foundation

enum Target {
    struct Middleware {
        let name: String
        let path: Path
        let dependencies: [String: [String]]
    }

    struct Output: Encodable, DictionaryConvertible, ContextConvertible {
        let name: String
        let path: Path
        let subpaths: [Path]
        let dependencies: [String: [Dependency.Output]]
    }
}



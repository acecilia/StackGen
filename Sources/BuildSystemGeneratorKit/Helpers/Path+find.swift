import Path

extension Path {
    func fastFindDirectories() throws -> [Path] {
        let output = try run(#"find "$(pwd)" -type d"#, directory: self)
        return output.components(separatedBy: .newlines).map {
            Path(PathishWrapper(string: $0))
        }
    }
}

/// Path has two initializers: one for String and one for Pathish. The one for String performs several checks on the String that makes it slow, so below code allows to use the Pathish initializer (which is more performant because it does not perform any checks) with String
private struct PathishWrapper: Pathish {
    let string: String
}

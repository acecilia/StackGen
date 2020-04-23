import Path

extension Path {
    func fastFindAll() throws -> [Path] {
        let output = try run("find .", directory: self)
        return output.components(separatedBy: .newlines).map { self/$0 }
    }
}

import Path

public extension Pathish {
    func find(name basename: String) -> [Path] {
        find()
            .type(.file)
            // Ignore paths
            .filter { file in
                return Current.globals.ignore.contains { file.string.hasPrefix($0.string) } == false
            }
            .filter { $0.basename() == basename }
    }
}

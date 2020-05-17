import Foundation
import Path

public extension Path {
    struct Output: Codable, Hashable {
        let path: Path
        let basename: String
        let parent: Path
    }

    var output: Output {
        return Output(
            path: self,
            basename: self.basename(),
            parent: self.parent
        )
    }
}

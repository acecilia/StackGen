import Foundation
import Path

extension Path {
    /// A path representation to be used when a path is needed inside the context
    public struct Output: Codable, Hashable {
        /// The absolut path to the file
        public let path: Path
        /// The corresponding basename
        public let basename: String
        /// The parent path
        public let parent: Path
    }

    public var output: Output {
        return Output(
            path: self,
            basename: self.basename(),
            parent: self.parent
        )
    }
}

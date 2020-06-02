import Foundation
import Path

extension TemplateEngine {
    public class Template {
        enum Kind {
            case path(Path)
            case string(String)
        }

        private let kind: Kind
        private var _content: String?

        public init(_ path: Path) {
            self.kind = .path(path)
        }

        public init(_ string: String) {
            self.kind = .string(string)
        }

        public var path: Path? {
            switch kind {
            case let .path(path):
                return path

            case .string:
                return nil
            }
        }

        public func content() throws -> String {
            switch kind {
            case let .path(path):
                if let content = _content {
                    return content
                } else {
                    let content = try String(contentsOf: path)
                    _content = content
                    return content
                }

            case let .string(string):
                return string
            }
        }
    }
}

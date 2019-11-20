import Foundation
import Path
import Yams

public enum ModuleFile {
    public struct Yaml: Codable {
        public let globals: Globals?
        public let modules: [String: Module.Yaml]?
//
//        private enum CodingKeys: CodingKey {
//            case globals, modules
//        }
//
//        public init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            self.globals = try container.decode(Globals.self, forKey: .globals)
//            if let modules = try container.decodeIfPresent([String: Module.Yaml].self, forKey: .modules) {
//                self.modules = modules
//            } else {
//                self.modules = [try Module.Yaml(from: decoder)]
//            }
//        }
//
//        public func encode(to encoder: Encoder) throws {
//            fatalError("TODO")
//        }

        public init(_ path: Path) throws {
            let content = try String(contentsOf: path)
            let decoder = YAMLDecoder()
            self = try decoder.decode(ModuleFile.Yaml.self, from: content, userInfo: [.relativePath: path])
        }
    }
}

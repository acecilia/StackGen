import Foundation
import Path

public struct TemplateSpec: Decodable {
    public let mode: Mode
}

public extension TemplateSpec {
    enum Mode: Decodable {
        public static let defaultModuleFilter = NSRegularExpression(".*")

        case module(filter: NSRegularExpression)
        case moduleToRoot(filter: NSRegularExpression)
        case root

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let singleValue = try? container.decode(SingleValue.self) {
                switch singleValue {
                case .module:
                    self = .module(filter: Self.defaultModuleFilter)

                case .moduleToRoot:
                    self = .moduleToRoot(filter: Self.defaultModuleFilter)

                case .root:
                    self = .root
                }
            } else {
                let fullValue = try container.decode(FullValue.self)
                switch fullValue {
                case let .module(filter):
                    self = .module(filter: filter?.wrappedValue ?? Self.defaultModuleFilter)

                case let .moduleToRoot(filter):
                    self = .moduleToRoot(filter: filter?.wrappedValue ?? Self.defaultModuleFilter)

                case .root:
                    self = .root
                }

            }
        }
    }
}

extension TemplateSpec.Mode {
    enum SingleValue: String, Codable {
        case module
        case moduleToRoot
        case root
    }

    enum FullValue: AutoCodable {
        case module(filter: RegularExpression?)
        case moduleToRoot(filter: RegularExpression?)
        case root
    }
}

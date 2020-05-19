import Foundation
import Path

/// A representation of the content expected for the templates file
public typealias TemplatesFile = [Path: TemplateSpec]

/// The specification for a template or a subdirectory of templates
public struct TemplateSpec: Decodable {
    /// The mode that declares how a template is used
    public let mode: Mode
}

extension TemplateSpec {
    /// The mode that declares how a template is used
    public enum Mode: Decodable {
        static let defaultModuleFilter = NSRegularExpression(".*")

        /// The module mode. In this mode the associated template will be executed once per
        /// each one of the declared first party modules. The generated file
        /// will be placed inside the directory containing the module. Also, it is possible
        /// to access the information of the module by using the `module` key that will become
        /// available in the context. Optionally you can pass a regex filter to select which of the
        /// modules to be used when rendering the template
        case module(filter: NSRegularExpression)
        /// The moduleToRoot mode. In this mode the associated template will be executed once per
        /// each one of the declared first party modules. The generated file
        /// will be placed at the root of the repository. Thus, it is important that each generated file
        /// has a different name, or otherwise they will be overwritten. Also, it is possible
        /// to access the information of the module by using the `module` key that will become
        /// available in the context. Optionally you can pass a regex filter to select which of the
        /// modules to be used when rendering the template
        case moduleToRoot(filter: NSRegularExpression)
        /// The root mode. In this mode the associated template will be executed only once.
        /// The generated file will be placed at the root of the repository.
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

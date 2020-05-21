import Foundation
import Path
import Compose

public enum TemplateSpec {
    /// The specification for a template file or a directory that contains template files
    public typealias Input = Compose<_Input, TemplateSpec.Mode>

    /// A partial representation of a TemplateSpec.Input
    public struct _Input: Decodable {
        /// The path of the template
        public let path: Path
    }

    /// The mode that declares how a template is used
    public enum Mode: AutoCodable {
        public static let defaultFilter = RegularExpression(".*")

        enum CodingKeys: String, CodingKey {
            case enumCaseKey = "mode"

// sourcery:inline:auto:TemplateSpec.Mode.CodingKeys.AutoCodable
        case module
        case moduleToRoot
        case root
        case filter
// sourcery:end
        }

        /// The module mode. In this mode the associated template will be executed once per
        /// each one of the declared first party modules. The generated file
        /// will be placed inside the directory containing the module. Also, it is possible
        /// to access the information of the module by using the `module` key that will become
        /// available in the context. Optionally you can pass a regex filter to select which of the
        /// modules to be used when rendering the template
        case module(filter: RegularExpression = Self.defaultFilter)
        /// The moduleToRoot mode. In this mode the associated template will be executed once per
        /// each one of the declared first party modules. The generated file
        /// will be placed at the root of the repository. Thus, it is important that each generated file
        /// has a different name, or otherwise they will be overwritten. Also, it is possible
        /// to access the information of the module by using the `module` key that will become
        /// available in the context. Optionally you can pass a regex filter to select which of the
        /// modules to be used when rendering the template
        case moduleToRoot(filter: RegularExpression = Self.defaultFilter)
        /// The root mode. In this mode the associated template will be executed only once.
        /// The generated file will be placed at the root of the repository.
        case root
    }
}

public extension TemplateSpec.Input {
    var mode: TemplateSpec.Mode { _element2 }
}

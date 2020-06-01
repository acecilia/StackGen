import SwiftTemplateEngine

let stackgenRuntimeFiles: [SwiftTemplate.File] = [
    .init(
        name: "Module.swift",
        content: """
import Foundation

public enum Module: Codable {
    case firstParty(FirstPartyModule.Output)
    case thirdParty(ThirdPartyModule.Output)

    private enum CodingKeys: String, CodingKey {
        case kind
    }

    public var name: String {
        switch self {
        case let .firstParty(module):
            return module.name

        case let .thirdParty(module):
            return module.name
        }
    }

    public var kind: ModuleKind {
        switch self {
        case .firstParty:
            return .firstParty

        case .thirdParty:
            return .thirdParty
        }
    }

    private var underlyingValue: Codable {
        switch self {
        case let .firstParty(module):
            return module

        case let .thirdParty(module):
            return module
        }
    }

    public func encode(to encoder: Encoder) throws {
        try underlyingValue.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kind, forKey: .kind)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(ModuleKind.self, forKey: .kind)
        switch kind {
        case .firstParty:
            let module = try FirstPartyModule.Output(from: decoder)
            self = .firstParty(module)

        case .thirdParty:
            let module = try ThirdPartyModule.Output(from: decoder)
            self = .thirdParty(module)
        }
    }
}
"""
    ),
    .init(
        name: "Context.swift",
        content: """
import Foundation
import Path
import StringCodable

/// A namespace grouping the entities representing the context to be passed to the templates
public enum Context {
    /// The initial representation of the context that will be passed to the templates
    public struct Input {
        public let global: [String: StringCodable]
        public let modules: [Module]

        public init(
            global: [String: StringCodable],
            modules: [Module]
        ) {
            self.global = global
            self.modules = modules
        }
    }

    /// The final representation of the context that will be passed to the templates
    public struct Output: Codable {
        /// The environment of the Context
        public let env: Env
        /// The global values defined in the stackgen.yml file
        public let global: [String: StringCodable]
        /// A list of the modules defined in the stackgen.yml file
        public let modules: [Module]
        /// The current module that is passed to the template, if any
        public let module: FirstPartyModule.Output?

        public init(
            env: Env,
            global: [String: StringCodable],
            modules: [Module],
            module: FirstPartyModule.Output?
        ) {
            self.env = env
            self.global = global
            self.modules = modules
            self.module = module
        }
    }

    /// The environment for a Context
    public struct Env: Codable, Hashable {
        /// The root path from where the tool runs
        public let root: Path.Output
        /// The output path of the file resulting from rendering a template with a context
        public let output: Path.Output

        public init(
            root: Path.Output,
            output: Path.Output
        ) {
            self.root = root
            self.output = output
        }
    }
}
"""
    ),
    .init(
        name: "FirstPartyModule.swift",
        content: """
import Foundation
import Path

/// A namespace grouping the entities representing a first party module
public enum FirstPartyModule {
    /// A representation of a first party module to be used inside the stackgen.yml file
    public struct Input: AutoCodable, Hashable {
        static let defaultDependencies: [String: [String]] = [:]

        /// The name of the module
        public var name: String { path.basename() }
        /// The path of the module
        public let path: Path
        /**
         A dictionary representing the dependencies of the module

         You can use any string value you want as key of the dictionary, but in general,
         the keys of the dictionary represent the kind of target. For example:

         ```
         {
            main: [ModuleA, ModuleB],
            UnitTests: [ModuleC],
            UITests: [ModuleD],
         }
         ```
         */
        public let dependencies: [String: [String]]

        public init(
            path: Path,
            dependencies: [String: [String]]
        ) {
            self.path = path
            self.dependencies = dependencies
        }
    }

    /// A representation of a first party module that is used in the context
    /// rendered by the templates
    public struct Output: Codable, Hashable {
        /// The name of the first party module
        public let name: String
        /// The location of the first party module
        public let location: Path.Output
        /// The dependencies of the first party module
        public let dependencies: [String: [String]]
        /// The transitive dependencies of the first party module
        public let transitiveDependencies: [String: [String]]

        public init(
            name: String,
            location: Path.Output,
            dependencies: [String: [String]],
            transitiveDependencies: [String: [String]]
        ) {
            self.name = name
            self.location = location
            self.dependencies = dependencies
            self.transitiveDependencies = transitiveDependencies
        }
    }
}
"""
    ),
    .init(
        name: "ThirdPartyModule.swift",
        content: """
import Foundation
import Path
import StringCodable
import Compose

/// A namespace grouping the entities representing a third party module
public enum ThirdPartyModule {
    /// The representation of a third party module, containing the typed and untyped properties.
    /// This allows to include custom keys-values in the third party modules, on top of the mandatory ones
    /// required by the typed representation. For example, you may want to add the following
    /// custom key-value: `repository: https://github.com/somebody/myThirdPartyModule`
    public typealias Input = Compose<_Input, [String: StringCodable]>
    /// The typed representation of a third party module
    public struct _Input: Codable {
        public let name: String
    }

    /// The representation of a third party module. Used in the context rendered by the templates
    public typealias Output = Compose<_Output, [String: StringCodable]>
    /// The typed representation of a third party module. Used in the context rendered by the templates
    public struct _Output: Codable, Hashable {
        public let name: String
    }
}

public extension Compose where Element2 == [String: StringCodable] {
    var dictionary: [String: StringCodable] { _element2 }
}
"""
    ),
    .init(
        name: "ModuleKind.swift",
        content: """
import Foundation

/// The kind of module
public enum ModuleKind: String, Codable, CaseIterable, Comparable {
    case firstParty
    case thirdParty

    public static func < (lhs: Self, rhs: Self) -> Bool {
        return allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}
"""
    ),
    .init(
        name: "Path+Output.swift",
        content: """
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
"""
    ),
    .init(
        name: "AutoCodable.swift",
        content: """
// MARK: sourcery related

protocol AutoDecodable: Decodable {}
protocol AutoEncodable: Encodable {}
protocol AutoCodable: AutoDecodable, AutoEncodable {}
"""
    ),
    .init(
        name: "Array+expand.swift",
        content: """
import Foundation

public extension Array where Element == String {
    func expand() -> [Module] {
        self.map { moduleName in
            guard let module = modules.first(where: { $0.name == moduleName }) else {
                fatalError("No module found for name '\\(moduleName)'")
            }
            return module
        }
    }
}
"""
    ),
    .init(
        name: "TopLevel.swift",
        content: """
import Foundation
import Path

public let context: Context.Output = {
    do {
        let contextData = try Data(contentsOf: Path(ProcessInfo().arguments[1])!)
        return try JSONDecoder().decode(Context.Output.self, from: contextData)
    } catch {
        fatalError("\\(error)")
    }
}()

public let env = context.env
public let global = context.global
public let modules = context.modules
public let module = context.module
"""
    ),
]
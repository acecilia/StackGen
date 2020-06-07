import Foundation

// MARK: Convenient protocols

extension FirstPartyModule.Input: ModuleProtocol { }
extension FirstPartyModule.Output: ModuleProtocol { }
extension ThirdPartyModule.Input: ModuleProtocol {
    public var name: String { typed.name }
}

public protocol ModuleProtocol: Equatable {
    var name: String { get }
}

protocol ModuleWrapperProtocol: ModuleProtocol {
    associatedtype FirstParty: ModuleProtocol
    associatedtype ThirdParty: ModuleProtocol

    var firstParty: FirstParty? { get }
    var thirdParty: ThirdParty? { get }
}

extension Module {
    /// A wrapper around the supported modules
    public enum Wrapper<
        FirstParty: Codable & ModuleProtocol,
        ThirdParty: Codable & ModuleProtocol
    >: Codable, Equatable {
        /// A first party module
        case firstParty(FirstParty)
        /// A third party module
        case thirdParty(ThirdParty)

        /// The name of the module
        public var name: String {
            switch self {
            case let .firstParty(module):
                return module.name

            case let .thirdParty(module):
                return module.name
            }
        }

        /// The kind of the module
        public var kind: ModuleKind {
            switch self {
            case .firstParty:
                return .firstParty

            case .thirdParty:
                return .thirdParty
            }
        }
    }
}

// MARK: Convenience

extension Module.Wrapper: Hashable {
    public var hashValue: Int {
        name.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        name.hash(into: &hasher)
    }
}

extension Module.Wrapper: ModuleWrapperProtocol {
    /// The wrapped first party module
    var firstParty: FirstParty? {
        switch self {
        case let .firstParty(module):
            return module

        case .thirdParty:
            return nil
        }
    }

    /// The wrapped third party module
    var thirdParty: ThirdParty? {
        switch self {
        case .firstParty:
            return nil

        case let .thirdParty(module):
            return module
        }
    }
}

extension Array where Element: ModuleWrapperProtocol {
    /// Convenient property to filter and map the first party modules
    var firstParty: [Element.FirstParty] {
        self.compactMap { $0.firstParty }
    }

    /// Convenient property to filter and map the third party modules
    var thirdParty: [Element.ThirdParty] {
        self.compactMap { $0.thirdParty }
    }

    /// Returns the module with the specified name, or throws
    func get(named name: String) throws -> Element {
        guard let element = self.first(where: { $0.name == name }) else {
            throw StackGenError(
                .unknownModule(
                    name,
                    self.firstParty.map { $0.name },
                    self.thirdParty.map { $0.name }
                )
            )
        }

        return element
    }
}

// MARK: Codable related

extension Module.Wrapper {
    private enum CodingKeys: String, CodingKey {
        case kind
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
            let module = try FirstParty(from: decoder)
            self = .firstParty(module)

        case .thirdParty:
            let module = try ThirdParty(from: decoder)
            self = .thirdParty(module)
        }
    }
}

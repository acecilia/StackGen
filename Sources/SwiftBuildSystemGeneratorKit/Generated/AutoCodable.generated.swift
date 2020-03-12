// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension Context {

    enum CodingKeys: String, CodingKey {
        case global
        case module
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let enumCase = try container.decode(String.self)
        switch enumCase {
        case CodingKeys.global.rawValue: self = .global
        case CodingKeys.module.rawValue: self = .module
        default: throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case '\(enumCase)'"))
        }
    }

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .global: try container.encode(CodingKeys.global.rawValue)
        case .module: try container.encode(CodingKeys.module.rawValue)
        }
    }

}

extension Global {

    enum CodingKeys: String, CodingKey {
        case ignore
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        ignore = (try? container.decode([Path].self, forKey: .ignore)) ?? Global.defaultIgnore
    }

}

extension Module.Input {

    enum CodingKeys: String, CodingKey {
        case name
        case dependencies
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        dependencies = (try? container.decode([String: [String]].self, forKey: .dependencies)) ?? Module.Input.defaultDependencies
    }

}

extension OutputLevel {

    enum CodingKeys: String, CodingKey {
        case root
        case module
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let enumCase = try container.decode(String.self)
        switch enumCase {
        case CodingKeys.root.rawValue: self = .root
        case CodingKeys.module.rawValue: self = .module
        default: throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case '\(enumCase)'"))
        }
    }

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .root: try container.encode(CodingKeys.root.rawValue)
        case .module: try container.encode(CodingKeys.module.rawValue)
        }
    }

}

// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Version
import Path
import StringCodable

extension BsgFile {

    enum CodingKeys: String, CodingKey {
        case custom
        case modules
        case versionSources
        case options
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        custom = (try? container.decode([String: StringCodable].self, forKey: .custom)) ?? BsgFile.defaultCustom
        modules = (try? container.decode([FirstPartyModule.Input].self, forKey: .modules)) ?? BsgFile.defaultModules
        versionSources = (try? container.decode([Path].self, forKey: .versionSources)) ?? BsgFile.defaultVersionSources
        options = (try? container.decode(Options.Input.self, forKey: .options)) ?? BsgFile.defaultOptions
    }

}

extension FirstPartyModule.Input {

    enum CodingKeys: String, CodingKey {
        case id
        case dependencies
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        dependencies = (try? container.decode([String: [String]].self, forKey: .dependencies)) ?? FirstPartyModule.Input.defaultDependencies
    }

}

extension TemplateSpec.Mode.FullValue {

    enum CodingKeys: String, CodingKey {
        case module
        case moduleToRoot
        case root
        case filter
    }

    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.allKeys.contains(.module), try container.decodeNil(forKey: .module) == false {
            let associatedValues = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .module)
            let filter = try associatedValues.decode(RegularExpression?.self, forKey: .filter)
            self = .module(filter: filter)
            return
        }
        if container.allKeys.contains(.moduleToRoot), try container.decodeNil(forKey: .moduleToRoot) == false {
            let associatedValues = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .moduleToRoot)
            let filter = try associatedValues.decode(RegularExpression?.self, forKey: .filter)
            self = .moduleToRoot(filter: filter)
            return
        }
        if container.allKeys.contains(.root), try container.decodeNil(forKey: .root) == false {
            self = .root
            return
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case"))
    }

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .module(filter):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .module)
            try associatedValues.encode(filter, forKey: .filter)
        case let .moduleToRoot(filter):
            var associatedValues = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .moduleToRoot)
            try associatedValues.encode(filter, forKey: .filter)
        case .root:
            _ = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .root)
        }
    }

}

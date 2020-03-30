// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Version
import Path

extension BsgFile {

    enum CodingKeys: String, CodingKey {
        case custom
        case modules
        case versionSources
        case options
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        custom = (try? container.decode([String: String].self, forKey: .custom)) ?? BsgFile.defaultCustom
        modules = (try? container.decode([FirstPartyModule.Input].self, forKey: .modules)) ?? BsgFile.defaultModules
        versionSources = (try? container.decode([Path].self, forKey: .versionSources)) ?? BsgFile.defaultVersionSources
        options = try container.decode(Options.self, forKey: .options)
    }

}

extension FirstPartyModule.Input {

    enum CodingKeys: String, CodingKey {
        case name
        case dependencies
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        dependencies = (try? container.decode([String: [String]].self, forKey: .dependencies)) ?? FirstPartyModule.Input.defaultDependencies
    }

}

extension TemplateFile {

    enum CodingKeys: String, CodingKey {
        case name
        case mode
        case subdir
        case moduleFilter
        case content
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        mode = try container.decode(Mode.self, forKey: .mode)
        subdir = (try? container.decode(String.self, forKey: .subdir)) ?? TemplateFile.defaultSubdir
        moduleFilter = (try? container.decode(RegularExpression.self, forKey: .moduleFilter)) ?? TemplateFile.defaultModuleFilter
        content = try container.decode(String.self, forKey: .content)
    }

}

extension TemplateFile.Mode {

    enum CodingKeys: String, CodingKey {
        case module
        case moduleToRoot
        case root
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let enumCase = try container.decode(String.self)
        switch enumCase {
        case CodingKeys.module.rawValue: self = .module
        case CodingKeys.moduleToRoot.rawValue: self = .moduleToRoot
        case CodingKeys.root.rawValue: self = .root
        default: throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case '\(enumCase)'"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .module: try container.encode(CodingKeys.module.rawValue)
        case .moduleToRoot: try container.encode(CodingKeys.moduleToRoot.rawValue)
        case .root: try container.encode(CodingKeys.root.rawValue)
        }
    }

}

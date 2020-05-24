// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Path
import StringCodable

extension FirstPartyModule.Input {

    enum CodingKeys: String, CodingKey {
        case path
        case dependencies
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        path = try container.decode(Path.self, forKey: .path)
        dependencies = (try? container.decode([String: [String]].self, forKey: .dependencies)) ?? FirstPartyModule.Input.defaultDependencies
    }

}

extension Options.StackGenFile {

    enum CodingKeys: String, CodingKey {
        case version
        case templateGroups
        case root
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        version = try container.decode(String.self, forKey: .version)
        templateGroups = (try? container.decode([String].self, forKey: .templateGroups)) ?? Options.StackGenFile.defaultTemplateGroups
        root = try container.decodeIfPresent(String.self, forKey: .root)
    }

}

extension StackGenFile {

    enum CodingKeys: String, CodingKey {
        case options
        case global
        case firstPartyModules
        case thirdPartyModules
        case availableTemplateGroups
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        options = try container.decode(Options.StackGenFile.self, forKey: .options)
        global = (try? container.decode([String: StringCodable].self, forKey: .global)) ?? StackGenFile.defaultGlobal
        firstPartyModules = (try? container.decode([FirstPartyModule.Input].self, forKey: .firstPartyModules)) ?? StackGenFile.defaultFirstPartyModules
        thirdPartyModules = (try? container.decode([ThirdPartyModule.Input].self, forKey: .thirdPartyModules)) ?? StackGenFile.defaultThirdPartyModules
        availableTemplateGroups = (try? container.decode([String: [TemplateSpec.Input]].self, forKey: .availableTemplateGroups)) ?? StackGenFile.defaultAvailableTemplateGroups
    }

}


extension TemplateSpec.Mode {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let enumCase = try container.decode(String.self, forKey: .enumCaseKey)
        switch enumCase {
        case CodingKeys.module.rawValue:
            let filter = (try? container.decode(RegularExpression.self, forKey: .filter)) ?? Self.defaultFilter
            self = .module(filter: filter)
        case CodingKeys.moduleToRoot.rawValue:
            let filter = (try? container.decode(RegularExpression.self, forKey: .filter)) ?? Self.defaultFilter
            self = .moduleToRoot(filter: filter)
        case CodingKeys.root.rawValue:
            self = .root
        default:
            throw DecodingError.dataCorruptedError(forKey: .enumCaseKey, in: container, debugDescription: "Unknown enum case '\(enumCase)'")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .module(filter):
            try container.encode(CodingKeys.module.rawValue, forKey: .enumCaseKey)
            try container.encode(filter, forKey: .filter)
        case let .moduleToRoot(filter):
            try container.encode(CodingKeys.moduleToRoot.rawValue, forKey: .enumCaseKey)
            try container.encode(filter, forKey: .filter)
        case .root:
            try container.encode(CodingKeys.root.rawValue, forKey: .enumCaseKey)
        }
    }

}

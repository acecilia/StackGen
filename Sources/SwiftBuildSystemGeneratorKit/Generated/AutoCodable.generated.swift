// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension Dependency.Yaml {

    enum CodingKeys: String, CodingKey {
        case module
        case framework
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if container.allKeys.contains(.module), try container.decodeNil(forKey: .module) == false {
            var associatedValues = try container.nestedUnkeyedContainer(forKey: .module)
            let associatedValue0 = try associatedValues.decode(Path.self)
            self = .module(associatedValue0)
            return
        }
        if container.allKeys.contains(.framework), try container.decodeNil(forKey: .framework) == false {
            var associatedValues = try container.nestedUnkeyedContainer(forKey: .framework)
            let associatedValue0 = try associatedValues.decode(String.self)
            self = .framework(associatedValue0)
            return
        }
        throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .module(associatedValue0):
            var associatedValues = container.nestedUnkeyedContainer(forKey: .module)
            try associatedValues.encode(associatedValue0)
        case let .framework(associatedValue0):
            var associatedValues = container.nestedUnkeyedContainer(forKey: .framework)
            try associatedValues.encode(associatedValue0)
        }
    }

}

extension Global {

    enum CodingKeys: String, CodingKey {
        case version
        case folderStructure
        case supportPath
        case ignore
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        version = try container.decode(Version.self, forKey: .version)
        folderStructure = (try? container.decode(FolderStructure.self, forKey: .folderStructure)) ?? Global.defaultFolderStructure
        supportPath = (try? container.decode(String.self, forKey: .supportPath)) ?? Global.defaultSupportPath
        ignore = (try? container.decode([Path].self, forKey: .ignore)) ?? Global.defaultIgnore
    }

}

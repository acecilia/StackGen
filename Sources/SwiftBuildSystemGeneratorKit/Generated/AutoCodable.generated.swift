// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


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

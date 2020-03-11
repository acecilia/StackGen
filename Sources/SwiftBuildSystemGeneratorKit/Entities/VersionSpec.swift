import Foundation

public enum VersionSpec: Decodable {
    case carthage(CartfileParentPath: Path)
    case custom(name: String, version: Version)

    enum CodingKeys: String, CodingKey {
        case carthage
    }

    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        let singleValueContainer = try decoder.singleValueContainer()

        if let cartfileParentPath = try keyedContainer.decodeIfPresent(Path.self, forKey: .carthage) {
            self = .carthage(CartfileParentPath: cartfileParentPath)
        } else if let pair = try? singleValueContainer.decode(CodablePair<Version>.self) {
            self = .custom(name: pair.key, version: pair.value)
        } else {
            throw DecodingError.dataCorruptedError(in: singleValueContainer, debugDescription: "Could not decode version spec")
        }
    }
}

struct CodablePair<Value: Decodable>: Decodable {
    let key: String
    let value: Value

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dict = try container.decode([String: Value].self)
        let pairs = dict.reduce(into: []) { $0.append($1) }
        switch pairs.count {
        case 1:
            let pair = pairs[0]
            self.key = pair.key
            self.value = pair.value

        default:
            fatalError()
        }
    }
}

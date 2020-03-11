import Foundation

public enum VersionSpec: Decodable {
    case carthage(CartfilePath: String)
    case custom(name: String, version: Version)

    enum CodingKeys: String, CodingKey {
        case carthage
    }

    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        let singleValueContainer = try decoder.singleValueContainer()

        if let cartfilePath = try keyedContainer.decodeIfPresent(String.self, forKey: .carthage) {
            self = .carthage(CartfilePath: cartfilePath)
        } else if let pair = try? singleValueContainer.decode(CodablePair<Version>.self) {
            self = .custom(name: pair.key, version: pair.value)
        } else {
            fatalError()
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

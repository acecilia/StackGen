import Path

public enum File: Codable, CustomStringConvertible {
    case glob(String)
    case path(Path)

    public var description: String {
        let rawValue: String

        switch self {
        case let .glob(string):
            rawValue = string

        case let .path(path):
            rawValue = path.string
        }

        return rawValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let path = Path(string) {
            self = .path(path)
        } else if string.contains("*") {
            self = .glob(string)
        } else {
            fatalError("Not a valid path")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

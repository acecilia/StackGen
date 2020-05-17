import Foundation
import Path
import Version
import StringCodable
import Compose

public struct ThirdPartyModule {
    public typealias Input = Compose<_Input, [String: StringCodable]>
    public struct _Input: Codable {
        public let name: String
    }

    public typealias Output = Compose<_Output, [String: StringCodable]>
    public struct _Output: Codable, Hashable {
        public let name: String
        public let kind: ModuleKind = .thirdParty
    }
}

extension Compose where Element2 == [String: StringCodable] {
    var dictionary: [String: StringCodable] { element2 }
}

import Foundation
import Path
import Version
import StringCodable
import Compose

public struct ThirdPartyModule {
    /// The representation of a third party module, containing the typed and untyped properties.
    /// This allows to include custom keys-values in the third party modules, on top of the mandatory ones
    /// required by the typed representation. For example, you may want to add the following
    /// custom key-value: `repository: https://github.com/somebody/myThirdPartyModule`
    public typealias Input = Compose<_Input, [String: StringCodable]>
    /// The typed representation of a third party module
    public struct _Input: Codable {
        public let name: String
    }

    /// The representation of a third party module. Used in the context rendered by the templates
    public typealias Output = Compose<_Output, [String: StringCodable]>
    /// The typed representation of a third party module. Used in the context rendered by the templates
    public struct _Output: Codable, Hashable {
        public let name: String
        public let kind: ModuleKind = .thirdParty
    }
}

extension Compose where Element2 == [String: StringCodable] {
    public var dictionary: [String: StringCodable] { element2 }
}

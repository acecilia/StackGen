import Foundation
import Path
import StringCodable

/// A namespace grouping the entities representing a third party module
public enum ThirdPartyModule {
    /// The representation of a third party module, containing the typed and untyped properties.
    /// This allows to include custom keys-values in the third party modules, on top of the mandatory ones
    /// required by the typed representation. For example, you may want to add the following
    /// custom key-value: `repository: https://github.com/somebody/myThirdPartyModule`
    public typealias Input = PartiallyTyped<_Input, [String: StringCodable]>
    /// The typed representation of a third party module
    public struct _Input: Codable {
        public let name: String
    }

    /// The representation of a third party module. Used in the context rendered by the templates
    public typealias Output = PartiallyTyped<_Output, [String: StringCodable]>
    /// The typed representation of a third party module. Used in the context rendered by the templates
    public struct _Output: Codable, Hashable {
        public let name: String
    }
}


import Foundation
import StringCodable

@dynamicMemberLookup
public protocol DictionaryDynamicLookup {
    associatedtype Key
    associatedtype Value
    subscript(key: Key) -> Value? { get }
}

extension DictionaryDynamicLookup where Key == String {
    public subscript(dynamicMember key: String) -> Value {
        guard let value = self[key] else {
            let error = StackGenError(.dictionaryKeyNotFound(key))
            fatalError(error.finalDescription)
        }
        return value
    }
}

extension Dictionary: DictionaryDynamicLookup { }

@dynamicMemberLookup
public protocol ThirdPartyDynamicLookup {
    var untyped: [String: StringCodable] { get }
}

extension ThirdPartyDynamicLookup {
    public subscript(dynamicMember key: String) -> StringCodable {
        return untyped[dynamicMember: key]
    }
}


extension ThirdPartyModule.Output: ThirdPartyDynamicLookup { }

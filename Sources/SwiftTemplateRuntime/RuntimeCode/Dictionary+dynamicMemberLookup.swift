import Foundation

@dynamicMemberLookup
protocol DictionaryDynamicLookup {
    associatedtype Key
    associatedtype Value
    subscript(key: Key) -> Value? { get }
}

extension DictionaryDynamicLookup where Key == String {
    subscript(dynamicMember key: String) -> Value {
        guard let value = self[key] else {
            let error = StackGenError(.dictionaryKeyNotFound(key))
            fatalError(error.finalDescription)
        }
        return value
    }
}

extension Dictionary: DictionaryDynamicLookup { }

import Foundation

/// A namespace grouping the entities use to represent a module
public enum Module {
    /// A wrapper around the input representation of all the supported modules
    public typealias Input = Module.Wrapper<FirstPartyModule.Input, ThirdPartyModule.Input>
    /// A wrapper around the output representation of all the supported modules
    public typealias Output = Module.Wrapper<FirstPartyModule.Output, ThirdPartyModule.Output>
}

// MARK: Convenience

extension Array where Element == Module.Input {
    /// Sort the modules by name and kind
    func sortedByNameAndKind() -> [Element] {
        return self
            .sortedAlphabetically(\.name)
            .sorted { $0.kind < $1.kind }
    }
}

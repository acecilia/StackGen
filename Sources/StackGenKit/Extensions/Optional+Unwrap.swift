extension Optional {
    /// Unwrap or throw
    /// From: https://ericasadun.com/2016/10/07/converting-optionals-to-thrown-errors/
    public func unwrap(onFailure description: String, file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let unwrapped = self else {
            throw StackGenError(
                .unexpected(description),
                file: file,
                line: line
            )
        }
        return unwrapped
    }

    /// Unwrap or throw
    func unwrap(onFailure kind: StackGenError.Kind, file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let unwrapped = self else {
            throw StackGenError(
                kind,
                file: file,
                line: line
            )
        }
        return unwrapped
    }
}

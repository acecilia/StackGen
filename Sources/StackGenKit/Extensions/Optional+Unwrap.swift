extension Optional {
    /// Unwrap or throw
    /// From: https://ericasadun.com/2016/10/07/converting-optionals-to-thrown-errors/
    public func unwrap(onFailure description: String, file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let unwrapped = self else {
            throw CustomError(
                .unexpected(description),
                file: file,
                line: line
            )
        }
        return unwrapped
    }

    /// Unwrap or throw
    func unwrap(onFailure kind: CustomError.Kind, file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let unwrapped = self else {
            throw CustomError(
                kind,
                file: file,
                line: line
            )
        }
        return unwrapped
    }
}

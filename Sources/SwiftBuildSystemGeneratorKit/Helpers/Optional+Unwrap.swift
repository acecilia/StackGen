extension Optional {
    /// From: https://ericasadun.com/2016/10/07/converting-optionals-to-thrown-errors/
    public func unwrap(onFailure description: String, file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let unwrapped = self else {
            throw UnexpectedError(description, file: file, line: line)
        }
        return unwrapped
    }
}

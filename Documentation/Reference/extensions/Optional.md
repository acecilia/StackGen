**EXTENSION**

# `Optional`
```swift
extension Optional
```

## Methods
### `unwrap(onFailure:file:line:)`

```swift
public func unwrap(onFailure description: String, file: String = #file, line: Int = #line) throws -> Wrapped
```

> Unwrap or throw
> From: https://ericasadun.com/2016/10/07/converting-optionals-to-thrown-errors/

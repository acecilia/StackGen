**CLASS**

# `Writer`

```swift
public class Writer
```

The service used to write files to disk

## Properties
### `writtenFiles`

```swift
public private(set) var writtenFiles: [Path] = []
```

### `shouldWrite`

```swift
public let shouldWrite: Bool
```

## Methods
### `init(shouldWrite:)`

```swift
public init(shouldWrite: Bool = true)
```

### `write(_:to:with:)`

```swift
public func write(_ string: String, to path: Path, with posixPermissions: Any?) throws
```

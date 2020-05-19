# Writer

The service used to write files to disk

``` swift
public class Writer
```

## Initializers

### `init(shouldWrite:)`

``` swift
public init(shouldWrite: Bool = true)
```

## Properties

### `writtenFiles`

``` swift
var writtenFiles: [Path]
```

### `shouldWrite`

``` swift
let shouldWrite: Bool
```

## Methods

### `write(_:to:with:)`

``` swift
public func write(_ string: String, to path: Path, with posixPermissions: Any?) throws
```

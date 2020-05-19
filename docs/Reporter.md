# Reporter

The service used to format the prints

``` swift
public class Reporter
```

## Initializers

### `init(silent:)`

``` swift
public init(silent: Bool = false)
```

## Properties

### `silent`

``` swift
let silent: Bool
```

## Methods

### `start(_:_:)`

``` swift
public func start(_ arguments: [String], _ cwd: Path)
```

### `info(_:_:)`

``` swift
public func info(_ emoji: Emoji, _ string: String)
```

### `warning(_:)`

``` swift
public func warning(_ string: String)
```

### `formatAsError(_:)`

``` swift
public func formatAsError(_ string: String) -> String
```

### `end()`

``` swift
public func end()
```

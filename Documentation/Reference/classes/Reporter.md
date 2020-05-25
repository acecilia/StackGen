**CLASS**

# `Reporter`

```swift
public class Reporter
```

> The service used to format the prints

## Properties
### `silent`

```swift
public let silent: Bool
```

## Methods
### `init(silent:)`

```swift
public init(silent: Bool = false)
```

### `start(_:_:)`

```swift
public func start(_ arguments: [String], _ cwd: Path)
```

### `info(_:_:)`

```swift
public func info(_ emoji: Emoji, _ string: String)
```

### `warning(_:)`

```swift
public func warning(_ string: String)
```

### `formatAsError(_:)`

```swift
public func formatAsError(_ string: String) -> String
```

### `end()`

```swift
public func end()
```

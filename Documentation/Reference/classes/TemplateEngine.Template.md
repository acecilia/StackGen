**CLASS**

# `TemplateEngine.Template`

```swift
public class Template
```

> The representation of a template, used to lazily load its content from disk

## Properties
### `path`

```swift
public var path: Path?
```

## Methods
### `init(_:)`

```swift
public init(_ path: Path)
```

### `init(_:)`

```swift
public init(_ string: String)
```

### `content()`

```swift
public func content() throws -> String
```

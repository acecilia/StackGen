**STRUCT**

# `Context.Env`

```swift
public struct Env: Codable, Hashable
```

> The environment for a Context

## Properties
### `root`

```swift
public let root: Path
```

> The root path from where the tool runs

### `output`

```swift
public let output: Path
```

> The output path of the file resulting from rendering a template with a context

## Methods
### `init(root:output:)`

```swift
public init(
    root: Path,
    output: Path
)
```

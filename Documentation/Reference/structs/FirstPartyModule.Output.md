**STRUCT**

# `FirstPartyModule.Output`

```swift
public struct Output: Codable, Hashable
```

> A representation of a first party module that is used in the context
> rendered by the templates

## Properties
### `name`

```swift
public let name: String
```

> The name of the first party module

### `path`

```swift
public let path: Path
```

> The location of the first party module

### `dependencies`

```swift
public let dependencies: [String: [String]]
```

> The dependencies of the first party module

### `transitiveDependencies`

```swift
public let transitiveDependencies: [String: [String]]
```

> The transitive dependencies of the first party module

## Methods
### `init(name:path:dependencies:transitiveDependencies:)`

```swift
public init(
    name: String,
    path: Path,
    dependencies: [String: [String]],
    transitiveDependencies: [String: [String]]
)
```

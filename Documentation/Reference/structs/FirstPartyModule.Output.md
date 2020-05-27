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

### `location`

```swift
public let location: Path.Output
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

### `kind`

```swift
public let kind: ModuleKind = .firstParty
```

> The kind of dependency that this module represents

## Methods
### `init(name:location:dependencies:transitiveDependencies:)`

```swift
public init(
    name: String,
    location: Path.Output,
    dependencies: [String: [String]],
    transitiveDependencies: [String: [String]]
)
```

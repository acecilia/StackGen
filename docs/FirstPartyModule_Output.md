# FirstPartyModule.Output

A representation of a first party module that is used in the context
rendered by the templates

``` swift
public struct Output: Codable, Hashable
```

## Inheritance

`Codable`, `Hashable`

## Initializers

### `init(name:location:dependencies:transitiveDependencies:)`

``` swift
public init(name: String, location: Path.Output, dependencies: [String: [String]], transitiveDependencies: [String: [String]])
```

## Properties

### `name`

The name of the first party module

``` swift
let name: String
```

### `location`

The location of the first party module

``` swift
let location: Path.Output
```

### `dependencies`

The dependencies of the first party module

``` swift
let dependencies: [String: [String]]
```

### `transitiveDependencies`

The transitive dependencies of the first party module

``` swift
let transitiveDependencies: [String: [String]]
```

### `kind`

The kind of dependency that this module represents

``` swift
let kind: ModuleKind
```

# FirstPartyModule.Input

A representation of a first party module to be used inside the stackgen.yml file

``` swift
public struct Input: AutoCodable, Hashable
```

## Inheritance

`Hashable`, [`Module`](Module), [`AutoCodable`](AutoCodable)

## Initializers

### `init(path:dependencies:)`

``` swift
public init(path: Path, dependencies: [String: [String]])
```

### `init(from:)`

``` swift
public init(from decoder: Decoder) throws
```

## Properties

### `defaultDependencies`

``` swift
let defaultDependencies: [String: [String]]
```

### `name`

The name of the module

``` swift
var name: String
```

### `path`

The path of the module

``` swift
let path: Path
```

### `dependencies`

A dictionary representing the dependencies of the module

``` swift
let dependencies: [String: [String]]
```

You can use any string value you want as key of the dictionary, but in general,
the keys of the dictionary represent the kind of target. For example:

``` 
{
   main: [ModuleA, ModuleB],
   UnitTests: [ModuleC],
   UITests: [ModuleD],
}
```

### `kind`

``` swift
var kind: ModuleKind
```

**STRUCT**

# `FirstPartyModule.Input`

```swift
public struct Input: AutoCodable, Hashable
```

> A representation of a first party module to be used inside the stackgen.yml file

## Properties
### `name`

```swift
public var name: String
```

> The name of the module

### `path`

```swift
public let path: String
```

> The path of the module

### `dependencies`

```swift
public let dependencies: [String: [String]]
```

> A dictionary representing the dependencies of the module
>
> You can use any string value you want as key of the dictionary, but in general,
> the keys of the dictionary represent the kind of target. For example:
>
> ```
> {
>    main: [ModuleA, ModuleB],
>    UnitTests: [ModuleC],
>    UITests: [ModuleD],
> }
> ```

## Methods
### `init(path:dependencies:)`

```swift
public init(
    path: String,
    dependencies: [String: [String]]
)
```

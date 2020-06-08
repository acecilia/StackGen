**STRUCT**

# `Context.Input`

```swift
public struct Input
```

> The initial representation of the context that will be passed to the templates

## Properties
### `global`

```swift
public let global: [String: StringCodable]
```

> The global values defined in the stackgen.yml file

### `modules`

```swift
public let modules: [Module.Output]
```

> A list of the modules defined in the stackgen.yml file

## Methods
### `init(global:modules:)`

```swift
public init(
    global: [String: StringCodable],
    modules: [Module.Output]
)
```

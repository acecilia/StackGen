**STRUCT**

# `Context.Middleware`

```swift
public struct Middleware: Codable
```

> A middleware representation of the context that will be passed to the templates

## Properties
### `firstPartyModules`

```swift
public let firstPartyModules: [FirstPartyModule.Output]
```

### `thirdPartyModules`

```swift
public let thirdPartyModules: [ThirdPartyModule.Output]
```

### `output`

```swift
public let output: Output
```

## Methods
### `init(firstPartyModules:thirdPartyModules:output:)`

```swift
public init(
    firstPartyModules: [FirstPartyModule.Output],
    thirdPartyModules: [ThirdPartyModule.Output],
    output: Output
)
```

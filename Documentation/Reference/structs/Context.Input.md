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

### `firstPartyModules`

```swift
public let firstPartyModules: [FirstPartyModule.Output]
```

### `firstPartyModuleNames`

```swift
public let firstPartyModuleNames: [String]
```

### `thirdPartyModules`

```swift
public let thirdPartyModules: [ThirdPartyModule.Output]
```

### `thirdPartyModuleNames`

```swift
public let thirdPartyModuleNames: [String]
```

## Methods
### `init(global:firstPartyModules:thirdPartyModules:)`

```swift
public init(
    global: [String: StringCodable],
    firstPartyModules: [FirstPartyModule.Output],
    thirdPartyModules: [ThirdPartyModule.Output]
)
```

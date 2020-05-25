# Context.Input

The initial representation of the context that will be passed to the templates

``` swift
public struct Input
```

## Initializers

### `init(global:firstPartyModules:thirdPartyModules:)`

``` swift
public init(global: [String: StringCodable], firstPartyModules: [FirstPartyModule.Output], thirdPartyModules: [ThirdPartyModule.Output])
```

## Properties

### `global`

``` swift
let global: [String: StringCodable]
```

### `firstPartyModules`

``` swift
let firstPartyModules: [FirstPartyModule.Output]
```

### `firstPartyModuleNames`

``` swift
let firstPartyModuleNames: [String]
```

### `thirdPartyModules`

``` swift
let thirdPartyModules: [ThirdPartyModule.Output]
```

### `thirdPartyModuleNames`

``` swift
let thirdPartyModuleNames: [String]
```

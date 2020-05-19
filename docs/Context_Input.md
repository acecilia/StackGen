# Context.Input

The initial representation of the context that will be passed to the templates

``` swift
public struct Input
```

## Initializers

### `init(custom:firstPartyModules:thirdPartyModules:templatesFilePath:)`

``` swift
public init(custom: [String: StringCodable], firstPartyModules: [FirstPartyModule.Output], thirdPartyModules: [ThirdPartyModule.Output], templatesFilePath: Path)
```

## Properties

### `custom`

``` swift
let custom: [String: StringCodable]
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

### `templatesFilePath`

``` swift
let templatesFilePath: Path
```

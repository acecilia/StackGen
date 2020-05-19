# Context.Middleware

A middleware representation of the context that will be passed to the templates

``` swift
public struct Middleware
```

## Initializers

### `init(firstPartyModules:thirdPartyModules:output:)`

``` swift
public init(firstPartyModules: [FirstPartyModule.Output], thirdPartyModules: [ThirdPartyModule.Output], output: Output)
```

## Properties

### `firstPartyModules`

``` swift
let firstPartyModules: [FirstPartyModule.Output]
```

### `thirdPartyModules`

``` swift
let thirdPartyModules: [ThirdPartyModule.Output]
```

### `output`

``` swift
let output: Output
```

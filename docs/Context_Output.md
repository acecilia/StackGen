# Context.Output

The final representation of the context that will be passed to the templates

``` swift
public struct Output: Codable
```

## Inheritance

`Codable`

## Initializers

### `init(custom:firstPartyModules:thirdPartyModules:global:module:)`

``` swift
public init(custom: [String: StringCodable], firstPartyModules: [String], thirdPartyModules: [String], global: Global, module: FirstPartyModule.Output?)
```

## Properties

### `custom`

The custom values defined in the stackgen.yml file

``` swift
let custom: [String: StringCodable]
```

### `firstPartyModules`

A list of the first party modules defined in the stackgen.yml file

``` swift
let firstPartyModules: [String]
```

### `thirdPartyModules`

A list of the third party modules defined in the stackgen.yml file

``` swift
let thirdPartyModules: [String]
```

### `global`

Several useful global values

``` swift
let global: Global
```

### `module`

The current module that is passed to the template, if any

``` swift
let module: FirstPartyModule.Output?
```

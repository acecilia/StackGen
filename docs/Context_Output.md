# Context.Output

The final representation of the context that will be passed to the templates

``` swift
public struct Output: Codable
```

## Inheritance

`Codable`

## Initializers

### `init(env:global:firstPartyModules:thirdPartyModules:module:)`

``` swift
public init(env: Env, global: [String: StringCodable], firstPartyModules: [String], thirdPartyModules: [String], module: FirstPartyModule.Output?)
```

## Properties

### `env`

The environment of the Context

``` swift
let env: Env
```

### `global`

The global values defined in the stackgen.yml file

``` swift
let global: [String: StringCodable]
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

### `module`

The current module that is passed to the template, if any

``` swift
let module: FirstPartyModule.Output?
```

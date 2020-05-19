# StackGenFile

The representation of the stackgen.yml file

``` swift
public struct StackGenFile: AutoCodable
```

## Inheritance

[`AutoCodable`](/AutoCodable)

## Properties

### `fileName`

``` swift
let fileName
```

### `defaultCustom`

``` swift
let defaultCustom: [String: StringCodable]
```

### `defaultFirstPartyModules`

``` swift
let defaultFirstPartyModules: [FirstPartyModule.Input]
```

### `defaultThirdPartyModules`

``` swift
let defaultThirdPartyModules: [ThirdPartyModule.Input]
```

### `defaultOptions`

``` swift
let defaultOptions: Options.StackGenFile
```

### `custom`

A dictionary used to declare custom values that can be accessed from
all the templates

``` swift
let custom: [String: StringCodable]
```

### `firstPartyModules`

The first party modules to use

``` swift
let firstPartyModules: [FirstPartyModule.Input]
```

### `thirdPartyModules`

The third party modules to use

``` swift
let thirdPartyModules: [ThirdPartyModule.Input]
```

### `options`

The options passed to the tool

``` swift
let options: Options.StackGenFile
```

## Methods

### `resolve(_:)`

``` swift
static func resolve(_ env: Env) throws -> StackGenFile
```

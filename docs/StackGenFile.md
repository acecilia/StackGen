# StackGenFile

The representation of the stackgen.yml file

``` swift
public struct StackGenFile: AutoDecodable
```

## Inheritance

[`AutoDecodable`](AutoDecodable.md)

## Initializers

### `init(options:global:firstPartyModules:thirdPartyModules:availableTemplateGroups:)`

``` swift
public init(options: Options.StackGenFile = Options.StackGenFile(version: VERSION), global: [String: StringCodable] = defaultGlobal, firstPartyModules: [FirstPartyModule.Input] = defaultFirstPartyModules, thirdPartyModules: [ThirdPartyModule.Input] = defaultThirdPartyModules, availableTemplateGroups: [String: [TemplateSpec.Input]] = defaultAvailableTemplateGroups)
```

## Properties

### `fileName`

``` swift
let fileName
```

### `defaultGlobal`

``` swift
let defaultGlobal: [String: StringCodable]
```

### `defaultFirstPartyModules`

``` swift
let defaultFirstPartyModules: [FirstPartyModule.Input]
```

### `defaultThirdPartyModules`

``` swift
let defaultThirdPartyModules: [ThirdPartyModule.Input]
```

### `defaultAvailableTemplateGroups`

``` swift
let defaultAvailableTemplateGroups: [String: [TemplateSpec.Input]]
```

### `options`

The options passed to the tool

``` swift
let options: Options.StackGenFile
```

### `global`

A dictionary used to declare global values that can be accessed from all the templates

``` swift
let global: [String: StringCodable]
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

### `availableTemplateGroups`

The template groups to use

``` swift
let availableTemplateGroups: [String: [TemplateSpec.Input]]
```

## Methods

### `resolve(_:)`

``` swift
static func resolve(_ env: Env) throws -> StackGenFile
```

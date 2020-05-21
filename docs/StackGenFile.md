# StackGenFile

The representation of the stackgen.yml file

``` swift
public struct StackGenFile: AutoDecodable
```

## Inheritance

[`AutoDecodable`](AutoDecodable.md)

## Initializers

### `init(options:custom:firstPartyModules:thirdPartyModules:availableTemplateGroups:)`

``` swift
public init(options: Options.StackGenFile = Options.StackGenFile(version: VERSION), custom: [String: StringCodable] = defaultCustom, firstPartyModules: [FirstPartyModule.Input] = defaultFirstPartyModules, thirdPartyModules: [ThirdPartyModule.Input] = defaultThirdPartyModules, availableTemplateGroups: [String: [TemplateSpec.Input]] = defaultAvailableTemplateGroups)
```

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

### `defaultAvailableTemplateGroups`

``` swift
let defaultAvailableTemplateGroups: [String: [TemplateSpec.Input]]
```

### `options`

The options passed to the tool

``` swift
let options: Options.StackGenFile
```

### `custom`

A dictionary used to declare custom values that can be accessed from all the templates

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

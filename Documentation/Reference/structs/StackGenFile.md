**STRUCT**

# `StackGenFile`

```swift
public struct StackGenFile: AutoDecodable
```

> The representation of the stackgen.yml file

## Properties
### `options`

```swift
public let options: Options.StackGenFile
```

> The options passed to the tool

### `global`

```swift
public let global: [String: StringCodable]
```

> A dictionary used to declare global values that can be accessed from all the templates

### `firstPartyModules`

```swift
public let firstPartyModules: [FirstPartyModule.Input]
```

> The first party modules to use

### `thirdPartyModules`

```swift
public let thirdPartyModules: [ThirdPartyModule.Input]
```

> The third party modules to use

### `availableTemplateGroups`

```swift
public let availableTemplateGroups: [String: [TemplateSpec.Input]]
```

> The template groups to use

## Methods
### `init(options:global:firstPartyModules:thirdPartyModules:availableTemplateGroups:)`

```swift
public init(
    options: Options.StackGenFile = Options.StackGenFile(version: Constant.version),
    global: [String: StringCodable] = defaultGlobal,
    firstPartyModules: [FirstPartyModule.Input] = defaultFirstPartyModules,
    thirdPartyModules: [ThirdPartyModule.Input] = defaultThirdPartyModules,
    availableTemplateGroups: [String: [TemplateSpec.Input]] = defaultAvailableTemplateGroups
)
```

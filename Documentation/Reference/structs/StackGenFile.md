**STRUCT**

# `StackGenFile`

```swift
public struct StackGenFile: AutoCodable
```

The representation of the stackgen.yml file

## Properties
### `options`

```swift
public let options: Options.StackGenFile
```

The options passed to the tool

### `global`

```swift
public let global: [String: StringCodable]
```

A dictionary used to declare global values that can be accessed from all the templates

### `firstPartyModules`

```swift
public let firstPartyModules: [FirstPartyModule.Input]
```

The first party modules to use

### `thirdPartyModules`

```swift
public let thirdPartyModules: [ThirdPartyModule.Input]
```

The third party modules to use

### `availableTemplateGroups`

```swift
public let availableTemplateGroups: [String: [TemplateSpec.Input]]
```

The template groups to use

### `lintOptions`

```swift
public let lintOptions: LintOptions
```

The lint options to use

## Methods
### `init(options:global:firstPartyModules:thirdPartyModules:availableTemplateGroups:lintOptions:)`

```swift
public init(
    options: Options.StackGenFile = Options.StackGenFile(),
    global: [String: StringCodable] = defaultGlobal,
    firstPartyModules: [FirstPartyModule.Input] = defaultFirstPartyModules,
    thirdPartyModules: [ThirdPartyModule.Input] = defaultThirdPartyModules,
    availableTemplateGroups: [String: [TemplateSpec.Input]] = defaultAvailableTemplateGroups,
    lintOptions: LintOptions = defaultLintOptions
)
```

### `resolve(_:)`

```swift
public static func resolve(_ env: inout Env) throws -> StackGenFile?
```

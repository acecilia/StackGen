**STRUCT**

# `Options.StackGenFile`

```swift
public struct StackGenFile: AutoCodable
```

> The options that the tool accepts through the stackgen.yml file

## Properties
### `version`

```swift
public let version: String
```

> The version of StackGen to be used with this stackgen.yml file

### `templateGroups`

```swift
public let templateGroups: [String]
```

> The template groups to use

### `root`

```swift
public let root: String?
```

> A custom repository root to be used, if it is not the cwd

## Methods
### `init(version:templateGroups:root:)`

```swift
public init(
    version: String,
    templateGroups: [String] = defaultTemplateGroups,
    root: String? = nil
)
```

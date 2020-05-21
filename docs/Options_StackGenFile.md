# Options.StackGenFile

The options that the tool accepts through the stackgen.yml file

``` swift
public struct StackGenFile: AutoCodable
```

## Inheritance

[`AutoCodable`](AutoCodable.md)

## Initializers

### `init(version:templateGroups:root:)`

``` swift
public init(version: String, templateGroups: [String] = defaultTemplateGroups, root: String? = nil)
```

### `init(from:)`

``` swift
public init(from decoder: Decoder) throws
```

### `init(from:)`

``` swift
public init(from decoder: Decoder) throws
```

## Properties

### `defaultTemplateGroups`

``` swift
let defaultTemplateGroups: [String]
```

### `version`

The version of StackGen to be used with this stackgen.yml file

``` swift
let version: String
```

### `templateGroups`

The template groups to use

``` swift
let templateGroups: [String]
```

### `root`

A custom repository root to be used, if it is not the cwd

``` swift
let root: String?
```

# Options.StackGenFile

The options that the tool accepts through the stackgen.yml file

``` swift
public struct StackGenFile: Codable
```

## Inheritance

`Codable`

## Initializers

### `init(version:templates:root:)`

``` swift
public init(version: String, templates: String? = nil, root: String? = nil)
```

### `init(from:)`

``` swift
public init(from decoder: Decoder) throws
```

## Properties

### `version`

The version of StackGen to be used with this stackgen.yml file

``` swift
let version: String
```

### `templates`

The templates identification to be used

``` swift
let templates: String?
```

### `root`

A custom repository root to be used, if it is not the cwd

``` swift
let root: String?
```

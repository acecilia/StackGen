# Options.StackGenFile

The options that the tool accepts through the stackgen.yml file

``` swift
public struct StackGenFile: Codable
```

## Inheritance

`Codable`

## Initializers

### `init(templates:root:)`

``` swift
public init(templates: String? = nil, root: String? = nil)
```

### `init(from:)`

``` swift
public init(from decoder: Decoder) throws
```

## Properties

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

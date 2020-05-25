# Context.Env

The environment for a Context

``` swift
public struct Env: Codable, Hashable
```

## Inheritance

`Codable`, `Hashable`

## Initializers

### `init(root:output:)`

``` swift
public init(root: Path.Output, output: Path.Output)
```

## Properties

### `root`

The root path from where the tool runs

``` swift
let root: Path.Output
```

### `output`

The output path of the file resulting from rendering a template with a context

``` swift
let output: Path.Output
```

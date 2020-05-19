# Global

Global values to be injected in all template contexts

``` swift
public struct Global: Codable, Hashable
```

## Inheritance

`Codable`, `Hashable`

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

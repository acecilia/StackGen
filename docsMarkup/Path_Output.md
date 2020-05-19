# Path.Output

A path representation to be used when a path is needed inside the context

``` swift
public struct Output: Codable, Hashable
```

## Inheritance

`Codable`, `Hashable`

## Properties

### `path`

The absolut path to the file

``` swift
let path: Path
```

### `basename`

The corresponding basename

``` swift
let basename: String
```

### `parent`

The parent path

``` swift
let parent: Path
```

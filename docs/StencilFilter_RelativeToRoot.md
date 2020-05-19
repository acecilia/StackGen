# StencilFilter.RelativeToRoot

An stencil filter that returns the path relative to the root of the repository

``` swift
public class RelativeToRoot: StencilFilterInterface
```

## Inheritance

[`StencilFilterInterface`](StencilFilterInterface.md)

## Properties

### `filterName`

``` swift
let filterName
```

### `context`

``` swift
var context: Context.Middleware?
```

## Methods

### `run(_:)`

``` swift
public func run(_ value: Any?) throws -> Any
```

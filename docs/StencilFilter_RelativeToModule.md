# StencilFilter.RelativeToModule

An stencil filter that returns the path relative to the module being processed

``` swift
public class RelativeToModule: StencilFilterInterface
```

## Inheritance

[`StencilFilterInterface`](/StencilFilterInterface)

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

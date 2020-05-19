# StencilFilter.ExpandDependencies

An stencil filter that expands a list of dependency names to their corresponding module dictionaries

``` swift
public class ExpandDependencies: StencilFilterInterface
```

## Inheritance

[`StencilFilterInterface`](StencilFilterInterface)

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

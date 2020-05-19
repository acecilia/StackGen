# StencilFilterInterface

An interface shared between all stencil filters

``` swift
public protocol StencilFilterInterface: class
```

## Inheritance

`class`

## Requirements

## filterName

``` swift
var filterName: String
```

## context

``` swift
var context: Context.Middleware?
```

## run(\_:)

``` swift
func run(_ value: Any?) throws -> Any
```

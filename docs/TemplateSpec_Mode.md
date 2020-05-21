# TemplateSpec.Mode

The mode that declares how a template is used

``` swift
public enum Mode
```

## Inheritance

[`AutoCodable`](AutoCodable.md)

## Initializers

### `init(from:)`

``` swift
public init(from decoder: Decoder) throws
```

## Enumeration Cases

### `module`

The module mode. In this mode the associated template will be executed once per
each one of the declared first party modules. The generated file
will be placed inside the directory containing the module. Also, it is possible
to access the information of the module by using the `module` key that will become
available in the context. Optionally you can pass a regex filter to select which of the
modules to be used when rendering the template

``` swift
case module(filter: RegularExpression = Self.defaultFilter)
```

### `moduleToRoot`

The moduleToRoot mode. In this mode the associated template will be executed once per
each one of the declared first party modules. The generated file
will be placed at the root of the repository. Thus, it is important that each generated file
has a different name, or otherwise they will be overwritten. Also, it is possible
to access the information of the module by using the `module` key that will become
available in the context. Optionally you can pass a regex filter to select which of the
modules to be used when rendering the template

``` swift
case moduleToRoot(filter: RegularExpression = Self.defaultFilter)
```

### `root`

The root mode. In this mode the associated template will be executed only once.
The generated file will be placed at the root of the repository.

``` swift
case root
```

## Properties

### `defaultFilter`

``` swift
let defaultFilter
```

## Methods

### `encode(to:)`

``` swift
public func encode(to encoder: Encoder) throws
```

# TemplatesFileResolver

The service in charge of resolving which templates file to use

``` swift
public struct TemplatesFileResolver
```

## Initializers

### `init(_:_:)`

``` swift
public init(_ availableTemplateGroups: [String: [TemplateSpec.Input]], _ env: Env)
```

## Properties

### `availableTemplateGroups`

``` swift
let availableTemplateGroups: [String: [TemplateSpec.Input]]
```

### `env`

``` swift
let env: Env
```

## Methods

### `resolve(_:)`

``` swift
public func resolve(_ templateGroups: [String]) throws -> [TemplateSpec.Input]
```

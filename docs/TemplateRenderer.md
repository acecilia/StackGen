# TemplateRenderer

The service in charge of passing the context to the templates, render them
and write them to disk

``` swift
public class TemplateRenderer
```

## Initializers

### `init(_:_:)`

``` swift
public init(_ inputContext: Context.Input, _ env: Env)
```

## Properties

### `inputContext`

``` swift
let inputContext: Context.Input
```

### `templateEngine`

``` swift
let templateEngine: TemplateEngine
```

### `env`

``` swift
let env: Env
```

## Methods

### `render(templatePath:relativePath:mode:)`

``` swift
public func render(templatePath: Path, relativePath: String, mode: TemplateSpec.Mode) throws
```

### `_render(template:to:_:_:)`

``` swift
private func _render(template: String, to outputPath: Path, _ posixPermissions: Any?, _ module: FirstPartyModule.Output?) throws
```

### `createContext(module:outputPath:)`

``` swift
private func createContext(module: FirstPartyModule.Output? = nil, outputPath: Path) throws -> Context.Middleware
```

### `resolve(outputPath:module:)`

``` swift
private func resolve(outputPath: Path, module: FirstPartyModule.Output?) throws -> Path
```

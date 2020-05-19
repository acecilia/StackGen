# TemplateEngine

A wrapper around the template engine to use

``` swift
public class TemplateEngine
```

## Initializers

### `init(_:_:)`

``` swift
public init(_ templatesFilePath: Path, _ env: Env)
```

## Properties

### `environment`

``` swift
let environment: Environment
```

### `extensions`

``` swift
let extensions
```

## Methods

### `render(templateContent:context:)`

``` swift
public func render(templateContent: String, context: Context.Middleware) throws -> String
```

### `addNewLineDelimiters(_:)`

See: https://github.com/groue/GRMustache/issues/46\#issuecomment-19498046

``` swift
private func addNewLineDelimiters(_ value: String) -> String
```

### `removeNewLinesDelimiters(_:)`

``` swift
private func removeNewLinesDelimiters(_ value: String) -> String
```

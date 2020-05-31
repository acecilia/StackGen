**CLASS**

# `TemplateEngine.Swift`

```swift
public class Swift: TemplateEngineInterface
```

> A wrapper to render Swit templates

## Methods
### `init(_:)`

```swift
public init(_ env: Env) throws
```

### `deinit`

```swift
deinit
```

### `render(templateContent:context:)`

```swift
public func render(templateContent: String, context: Context.Middleware) throws -> String
```

### `render(path:context:)`

```swift
public func render(path: Path, context: Context.Middleware) throws -> String
```

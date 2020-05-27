**CLASS**

# `TemplateRenderer`

```swift
public class TemplateRenderer
```

> The service in charge of passing the context to the templates, render them
> and write them to disk

## Methods
### `init(_:_:)`

```swift
public init(_ inputContext: Context.Input, _ env: Env)
```

### `render(templatePath:relativePath:mode:)`

```swift
public func render(
    templatePath: Path,
    relativePath: String,
    mode: TemplateSpec.Mode
) throws
```

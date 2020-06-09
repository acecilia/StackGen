**STRUCT**

# `TemplatesFileResolver`

```swift
public struct TemplatesFileResolver
```

The service in charge of resolving which templates file to use

## Methods
### `init(_:_:)`

```swift
public init(_ availableTemplateGroups: [String: [TemplateSpec.Input]] ,_ env: Env)
```

### `resolve(_:)`

```swift
public func resolve(_ templateGroups: [String]) throws -> [TemplateSpec.Input]
```

**ENUM**

# `TemplateEngine.TemplateType`

```swift
public enum TemplateType
```

The supported template types

## Cases
### `stencil`

```swift
case stencil
```

### `plainText`

```swift
case plainText
```

## Methods
### `init(_:)`

```swift
public init(_ template: Template) throws
```

Detect the template kind. The first delimiter that appears will determine which kind it is

**ENUM**

# `TemplateKind`

```swift
public enum TemplateKind
```

## Cases
### `stencil`

```swift
case stencil
```

### `swift`

```swift
case swift
```

### `plainText`

```swift
case plainText
```

## Methods
### `init(_:)`

```swift
public init(_ string: String)
```

> Detect the template kind. The first delimiter that appears will determine which kind it is

**STRUCT**

# `PartiallyTyped`

```swift
public struct PartiallyTyped<Typed, Untyped>
```

An object that is type safe, while at the same time keeps its non type safe representation

## Properties
### `typed`

```swift
public var typed: Typed
```

### `untyped`

```swift
public var untyped: Untyped
```

## Methods
### `init(_:_:)`

```swift
public init(_ typed: Typed, _ untyped: Untyped)
```

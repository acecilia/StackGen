**STRUCT**

# `StackGenError`

```swift
public struct StackGenError: LocalizedError
```

The errors thrown by the tool

## Properties
### `kind`

```swift
public let kind: Kind
```

### `fileName`

```swift
public let fileName: String
```

### `line`

```swift
public let line: Int
```

### `errorDescription`

```swift
public var errorDescription: String?
```

## Methods
### `init(_:file:line:)`

```swift
public init(_ kind: Kind, file: String = #file, line: Int = #line)
```

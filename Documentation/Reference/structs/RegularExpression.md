**STRUCT**

# `RegularExpression`

```swift
public struct RegularExpression: Codable, ExpressibleByStringLiteral
```

> A wrapper around NSRegularExpression that can be encoded and decoded

## Properties
### `wrappedValue`

```swift
public let wrappedValue: NSRegularExpression
```

## Methods
### `init(stringLiteral:)`

```swift
public init(stringLiteral value: String)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| value | The value of the new instance. |

### `init(from:)`

```swift
public init(from decoder: Decoder) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| decoder | The decoder to read data from. |

### `encode(to:)`

```swift
public func encode(to encoder: Encoder) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| encoder | The encoder to write data to. |
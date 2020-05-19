# RegularExpression

A wrapper around NSRegularExpression that can be encoded and decoded

``` swift
@propertyWrapper public struct RegularExpression: Codable, ExpressibleByStringLiteral
```

## Inheritance

`Codable`, `ExpressibleByStringLiteral`

## Initializers

### `init(stringLiteral:)`

``` swift
public init(stringLiteral value: String)
```

### `init(from:)`

``` swift
public init(from decoder: Decoder) throws
```

## Properties

### `wrappedValue`

``` swift
let wrappedValue: NSRegularExpression
```

## Methods

### `encode(to:)`

``` swift
public func encode(to encoder: Encoder) throws
```

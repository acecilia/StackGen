# CustomError

The errors thrown by the tool

``` swift
public struct CustomError: Error
```

## Inheritance

`Error`

## Initializers

### `init(_:file:line:)`

``` swift
public init(_ kind: Kind, file: String = #file, line: Int = #line)
```

## Properties

### `kind`

``` swift
let kind: Kind
```

### `fileName`

``` swift
let fileName: String
```

### `line`

``` swift
let line: Int
```

### `description`

``` swift
var description: String
```

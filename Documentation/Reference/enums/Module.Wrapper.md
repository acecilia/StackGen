**ENUM**

# `Module.Wrapper`

```swift
public enum Wrapper<
    FirstParty: Codable & ModuleProtocol,
    ThirdParty: Codable & ModuleProtocol
>: Codable, Equatable
```

> A wrapper around the supported modules

## Cases
### `firstParty(_:)`

```swift
case firstParty(FirstParty)
```

> A first party module

### `thirdParty(_:)`

```swift
case thirdParty(ThirdParty)
```

> A third party module

## Properties
### `name`

```swift
public var name: String
```

> The name of the module

### `kind`

```swift
public var kind: ModuleKind
```

> The kind of the module

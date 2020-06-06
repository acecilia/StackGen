**ENUM**

# `Module`

```swift
public enum Module: Codable
```

> A wrapper around the supported modules

## Cases
### `firstParty(_:)`

```swift
case firstParty(FirstPartyModule.Output)
```

> A first party module

### `thirdParty(_:)`

```swift
case thirdParty(ThirdPartyModule.Output)
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

**ENUM**

# `ModuleKind`

```swift
public enum ModuleKind: String, Codable, CaseIterable, Comparable
```

The kind of module

## Cases
### `firstParty`

```swift
case firstParty
```

### `thirdParty`

```swift
case thirdParty
```

## Methods
### `<(_:_:)`

```swift
public static func < (lhs: Self, rhs: Self) -> Bool
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| lhs | A value to compare. |
| rhs | Another value to compare. |
**STRUCT**

# `Checks`

```swift
public struct Checks: AutoCodable
```

## Properties
### `modulesSorting`

```swift
public let modulesSorting: ModuleSorting
```

The sorting of first and third party modules inside the stackgen.yml file

### `dependenciesSorting`

```swift
public let dependenciesSorting: DependencySorting
```

The sorting of the module dependencies inside the stackgen.yml file

### `transitiveDependenciesDuplication`

```swift
public let transitiveDependenciesDuplication: Bool
```

To check for duplication of transitive dependencies

## Methods
### `init(modulesSorting:dependenciesSorting:transitiveDependenciesDuplication:)`

```swift
public init(
    modulesSorting: ModuleSorting = defaultModulesSorting,
    dependenciesSorting: DependencySorting = defaultDependenciesSorting,
    transitiveDependenciesDuplication: Bool = defaultTransitiveDependenciesDuplication
)
```

**CLASS**

# `Linter`

```swift
public class Linter
```

The service that lints the stackgen.yml file

## Methods
### `init(_:_:)`

```swift
public init(_ env: Env, _ lintOptions: LintOptions)
```

### `checkModulesSorting(_:)`

```swift
public func checkModulesSorting(_ stackgenFile: StackGenFile) throws
```

### `checkDependenciesSorting(_:_:)`

```swift
public func checkDependenciesSorting(_ stackgenFile: StackGenFile, _ modules: [Module.Input]) throws
```

### `checkTransitiveDependenciesDuplication(_:_:_:)`

```swift
public func checkTransitiveDependenciesDuplication(
    _ module: FirstPartyModule.Input,
    _ dependency: Module.Input,
    _ transitiveDependencies: Set<Module.Input>
) throws
```

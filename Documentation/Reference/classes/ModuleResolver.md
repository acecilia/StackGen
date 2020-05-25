**CLASS**

# `ModuleResolver`

```swift
public class ModuleResolver
```

> The service that resolves the modules specified in the stackgen.yml file

## Methods
### `init(_:_:)`

```swift
public init(_ stackgenFile: StackGenFile, _ env: Env) throws
```

### `resolve()`

```swift
public func resolve() throws -> (firstPartyModules: [FirstPartyModule.Output], thirdPartyModules: [ThirdPartyModule.Output])
```

> The entry point used to resolve the modules

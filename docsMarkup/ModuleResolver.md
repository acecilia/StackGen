# ModuleResolver

The service that resolves the modules specified in the stackgen.yml file

``` swift
public class ModuleResolver
```

## Initializers

### `init(_:_:)`

``` swift
public init(_ stackgenFile: StackGenFile, _ env: Env) throws
```

## Properties

### `stackgenFile`

``` swift
let stackgenFile: StackGenFile
```

### `transitiveDependenciesCache`

A cache used to speed up module resolution

``` swift
var transitiveDependenciesCache: [String: [Dependency]]
```

### `env`

``` swift
let env: Env
```

## Methods

### `resolve()`

The entry point used to resolve the modules

``` swift
public func resolve() throws -> (firstPartyModules: [FirstPartyModule.Output], thirdPartyModules: [ThirdPartyModule.Output])
```

### `ensureUniqueModuleNames(_:)`

``` swift
private func ensureUniqueModuleNames(_ stackgenFile: StackGenFile) throws
```

### `resolve(_:)`

``` swift
private func resolve(_ module: ThirdPartyModule.Input) -> ThirdPartyModule.Output
```

### `populateDependencyKeys(_:)`

Prefill dependency keys that do not have any dependency with empty arrays, so accessing them in the template is cleaner and safer
Instead of having to do: `{% for dependency in module.transitiveDependencies.main|default:"" %}`
We allow to just do: `{% for dependency in module.transitiveDependencies.main %}`

``` swift
private func populateDependencyKeys(_ modules: [FirstPartyModule.Input]) -> [FirstPartyModule.Input]
```

### `getTransitiveDependencies(_:_:_:)`

``` swift
private func getTransitiveDependencies(_ dependency: String, _ middleware: [FirstPartyModule.Input], _ thirdParty: [ThirdPartyModule.Output]) throws -> [Dependency]
```

### `getTransitiveDependencies(_:_:_:)`

``` swift
private func getTransitiveDependencies(_ module: FirstPartyModule.Input, _ middleware: [FirstPartyModule.Input], _ thirdParty: [ThirdPartyModule.Output]) throws -> [String: [String]]
```

### `resolve(_:_:_:)`

``` swift
private func resolve(_ module: FirstPartyModule.Input, _ middleware: [FirstPartyModule.Input], _ thirdParty: [ThirdPartyModule.Output]) throws -> FirstPartyModule.Output
```

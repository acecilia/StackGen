**STRUCT**

# `Context.Output`

```swift
public struct Output: Codable
```

> The final representation of the context that will be passed to the templates

## Properties
### `env`

```swift
public let env: Env
```

> The environment of the Context

### `global`

```swift
public let global: [String: StringCodable]
```

> The global values defined in the stackgen.yml file

### `modules`

```swift
public let modules: [Module]
```

> A list of the modules defined in the stackgen.yml file

### `module`

```swift
public let module: FirstPartyModule.Output?
```

> The current module that is passed to the template, if any

## Methods
### `init(env:global:modules:module:)`

```swift
public init(
    env: Env,
    global: [String: StringCodable],
    modules: [Module],
    module: FirstPartyModule.Output?
)
```

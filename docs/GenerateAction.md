# GenerateAction

The action corresponting to the `generate` subcommand

``` swift
public class GenerateAction: Action
```

## Inheritance

[`Action`](Action.md)

## Initializers

### `init(_:_:)`

``` swift
public init(_ cliOptions: Options.CLI, _ env: Env)
```

## Properties

### `cliOptions`

``` swift
let cliOptions: Options.CLI
```

### `env`

``` swift
var env: Env
```

## Methods

### `execute()`

``` swift
public func execute() throws
```

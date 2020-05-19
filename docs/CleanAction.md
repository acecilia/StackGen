# CleanAction

The action corresponting to the `clean` subcommand

``` swift
public class CleanAction: Action
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
let env: Env
```

## Methods

### `execute()`

``` swift
public func execute() throws
```

# Env

An environment wrapper used to inject dependencies around without
polluting the function signatures with multiple parameters

``` swift
public struct Env
```

## Initializers

### `init(cwd:root:reporter:writer:)`

``` swift
public init(cwd: Path = Path(Path.cwd), root: Path = Path(Path.cwd), reporter: Reporter = Reporter(), writer: Writer = Writer())
```

## Properties

### `cwd`

The current working directory

``` swift
let cwd: Path
```

### `root`

The root of the repository to use

``` swift
var root: Path
```

### `reporter`

The reporter used to format the output

``` swift
var reporter: Reporter
```

### `writer`

The type used to write files to disk

``` swift
var writer: Writer
```

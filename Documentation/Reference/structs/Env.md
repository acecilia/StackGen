**STRUCT**

# `Env`

```swift
public struct Env
```

> An environment wrapper used to inject dependencies around without
> polluting the function signatures with multiple parameters

## Properties
### `cwd`

```swift
public let cwd: Path
```

> The current working directory

### `root`

```swift
public var root: Path
```

> The root of the repository to use

### `reporter`

```swift
public var reporter: Reporter
```

> The reporter used to format the output

### `writer`

```swift
public var writer: Writer
```

> The type used to write files to disk

## Methods
### `init(cwd:root:reporter:writer:)`

```swift
public init(
    cwd: Path = Path(Path.cwd),
    root: Path = Path(Path.cwd),
    reporter: Reporter = Reporter(),
    writer: Writer = Writer()
)
```

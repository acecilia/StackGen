# TemplatesFileResolver

The service in charge of resolving which templates file to use

``` swift
public struct TemplatesFileResolver
```

## Initializers

### `init(_:)`

``` swift
public init(_ env: Env)
```

## Properties

### `bundledTemplateFileName`

``` swift
let bundledTemplateFileName
```

### `bundledTemplatesDirectoryName`

``` swift
let bundledTemplatesDirectoryName
```

### `env`

``` swift
let env: Env
```

## Methods

### `resolve(_:)`

``` swift
public func resolve(_ relativePath: String) throws -> (Path, TemplatesFile)
```

### `resolveFile(_:)`

``` swift
private func resolveFile(_ templateFilePath: Path) throws -> TemplatesFile
```

### `resolvePath(_:)`

``` swift
private func resolvePath(_ relativePath: String) throws -> Path
```

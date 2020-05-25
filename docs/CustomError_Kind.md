# CustomError.Kind

The kind of errors that the tool is expecing

``` swift
enum Kind
```

## Enumeration Cases

### `stackgenFileVersionNotMatching`

``` swift
case stackgenFileVersionNotMatching(_ version: String)
```

### `moduleNotFoundInFilesystem`

``` swift
case moduleNotFoundInFilesystem(_ moduleId: String)
```

### `unknownModule`

``` swift
case unknownModule(_ name: String, _ firstParty: [FirstPartyModule.Input], _ thirdParty: [ThirdPartyModule.Output])
```

### `foundDuplicatedModules`

``` swift
case foundDuplicatedModules(_ modules: [String])
```

### `foundDuplicatedDependencies`

``` swift
case foundDuplicatedDependencies(_ dependencies: [String], _ module: String)
```

### `multipleModulesWithSameNameFoundAmongDetectedModules`

``` swift
case multipleModulesWithSameNameFoundAmongDetectedModules(_ moduleName: String, _ detectedModules: [String])
```

### `requiredParameterNotFound`

``` swift
case requiredParameterNotFound(name: String)
```

### `templateGroupNotFound`

``` swift
case templateGroupNotFound(identifier: String)
```

### `errorThrownWhileRendering`

``` swift
case errorThrownWhileRendering(templatePath: String, error: Error)
```

### `filterFailed`

``` swift
case filterFailed(filter: String, reason: String)
```

### `unexpected`

``` swift
case unexpected(_ description: String)
```

## Properties

### `errorDescription`

``` swift
var errorDescription: String
```

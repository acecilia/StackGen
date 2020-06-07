**ENUM**

# `StackGenError.Kind`

```swift
public enum Kind: Equatable
```

> The kind of errors that the tool is expecing

## Cases
### `stackgenFileVersionNotMatching(_:)`

```swift
case stackgenFileVersionNotMatching(_ version: String)
```

### `moduleNotFoundInFilesystem(_:)`

```swift
case moduleNotFoundInFilesystem(_ moduleId: String)
```

### `unknownModule(_:_:_:)`

```swift
case unknownModule(_ name: String, _ firstParty: [String], _ thirdParty: [String])
```

### `foundDuplicatedModules(_:)`

```swift
case foundDuplicatedModules(_ modules: [String])
```

### `foundDuplicatedDependencies(_:_:)`

```swift
case foundDuplicatedDependencies(_ dependencies: [String], _ module: String)
```

### `foundDependencyCycle(_:)`

```swift
case foundDependencyCycle(_ modules: [String])
```

### `multipleModulesWithSameNameFoundAmongDetectedModules(_:_:)`

```swift
case multipleModulesWithSameNameFoundAmongDetectedModules(_ moduleName: String, _ detectedModules: [String])
```

### `requiredParameterNotFound(name:)`

```swift
case requiredParameterNotFound(name: String)
```

### `templateGroupNotFound(identifier:)`

```swift
case templateGroupNotFound(identifier: String)
```

### `errorThrownWhileRendering(templatePath:error:)`

```swift
case errorThrownWhileRendering(templatePath: String, error: String)
```

### `filterFailed(filter:reason:)`

```swift
case filterFailed(filter: String, reason: String)
```

### `unexpected(_:)`

```swift
case unexpected(_ description: String)
```

### `unknownModuleName(_:_:)`

```swift
case unknownModuleName(_ name: String, _ modules: [String])
```

### `dictionaryKeyNotFound(_:)`

```swift
case dictionaryKeyNotFound(_ key: String)
```

### `modulesSorting(_:_:)`

```swift
case modulesSorting(_ modules: [String], _ sortedModules: [String])
```

### `dependenciesSorting(_:_:_:_:)`

```swift
case dependenciesSorting(_ module: String, _ dependencyGroup: String, _ dependencies: [String], _ sortedDependencies: [String])
```

### `transitiveDependencyDuplication(_:_:)`

```swift
case transitiveDependencyDuplication(_ module: String, _ dependency: String)
```

## Properties
### `errorDescription`

```swift
public var errorDescription: String
```

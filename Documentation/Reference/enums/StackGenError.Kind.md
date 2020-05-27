**ENUM**

# `StackGenError.Kind`

```swift
enum Kind
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
case unknownModule(_ name: String, _ firstParty: [FirstPartyModule.Input], _ thirdParty: [ThirdPartyModule.Output])
```

### `foundDuplicatedModules(_:)`

```swift
case foundDuplicatedModules(_ modules: [String])
```

### `foundDuplicatedDependencies(_:_:)`

```swift
case foundDuplicatedDependencies(_ dependencies: [String], _ module: String)
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
case errorThrownWhileRendering(templatePath: String, error: Error)
```

### `filterFailed(filter:reason:)`

```swift
case filterFailed(filter: String, reason: String)
```

### `unexpected(_:)`

```swift
case unexpected(_ description: String)
```

## Properties
### `errorDescription`

```swift
public var errorDescription: String
```

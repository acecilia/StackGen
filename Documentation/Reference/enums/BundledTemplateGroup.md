**ENUM**

# `BundledTemplateGroup`

```swift
public enum BundledTemplateGroup: String, CaseIterable
```

> The template groups bundled with the tool

## Cases
### `StackGen_Swift_BuildSystem_Bazel`

```swift
case StackGen_Swift_BuildSystem_Bazel
```

### `StackGen_Swift_BuildSystem_Cocoapods`

```swift
case StackGen_Swift_BuildSystem_Cocoapods
```

### `StackGen_Swift_BuildSystem_Xcodegen`

```swift
case StackGen_Swift_BuildSystem_Xcodegen
```

### `StackGen_Swift_Starter_CommandLine`

```swift
case StackGen_Swift_Starter_CommandLine
```

## Properties
### `templates`

```swift
public var templates: [String: TemplateSpec.Mode]
```

> The templates that each template group contains

## Methods
### `convert()`

```swift
public func convert() throws -> [TemplateSpec.Input]
```

> Obtain the template specification for the templates inside the template group

### `getRootPath()`

```swift
public func getRootPath() throws -> Path
```

> Obtain the root path of the template group

# BundledTemplateGroup

The template groups bundled with the tool

``` swift
public enum BundledTemplateGroup
```

## Inheritance

`CaseIterable`, `String`

## Enumeration Cases

### `StackGen_Swift_BuildSystem_Bazel`

``` swift
case StackGen_Swift_BuildSystem_Bazel
```

### `StackGen_Swift_BuildSystem_Cocoapods`

``` swift
case StackGen_Swift_BuildSystem_Cocoapods
```

### `StackGen_Swift_BuildSystem_Xcodegen`

``` swift
case StackGen_Swift_BuildSystem_Xcodegen
```

### `StackGen_Swift_Starter_CommandLine`

``` swift
case StackGen_Swift_Starter_CommandLine
```

## Properties

### `bundledTemplatesParentDirectoryName`

``` swift
let bundledTemplatesParentDirectoryName
```

### `templates`

The templates that each template group contains

``` swift
var templates: [String: TemplateSpec.Mode]
```

## Methods

### `convert()`

Obtain the template specification for the templates inside the template group

``` swift
public func convert() throws -> [TemplateSpec.Input]
```

### `getRootPath()`

Obtain the root path of the template group

``` swift
public func getRootPath() throws -> Path
```

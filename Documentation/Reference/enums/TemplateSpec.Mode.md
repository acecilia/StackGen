**ENUM**

# `TemplateSpec.Mode`

```swift
public enum Mode: AutoCodable
```

The mode that declares how a template is used

## Cases
### `module(filter:)`

```swift
case module(filter: RegularExpression = Self.defaultFilter)
```

The module mode. In this mode the associated template will be executed once per
each one of the declared first party modules. The generated file
will be placed inside the directory containing the module. Also, it is possible
to access the information of the module by using the `module` key that will become
available in the context. Optionally you can pass a regex filter to select which of the
modules to be used when rendering the template

### `moduleToRoot(filter:)`

```swift
case moduleToRoot(filter: RegularExpression = Self.defaultFilter)
```

The moduleToRoot mode. In this mode the associated template will be executed once per
each one of the declared first party modules. The generated file
will be placed at the root of the repository. Thus, it is important that each generated file
has a different name, or otherwise they will be overwritten. Also, it is possible
to access the information of the module by using the `module` key that will become
available in the context. Optionally you can pass a regex filter to select which of the
modules to be used when rendering the template

### `root`

```swift
case root
```

The root mode. In this mode the associated template will be executed only once.
The generated file will be placed at the root of the repository.

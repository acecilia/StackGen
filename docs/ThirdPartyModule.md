# ThirdPartyModule

A namespace grouping the entities representing a third party module

``` swift
public struct ThirdPartyModule
```

## Nested Type Aliases

### `Input`

The representation of a third party module, containing the typed and untyped properties.
This allows to include custom keys-values in the third party modules, on top of the mandatory ones
required by the typed representation. For example, you may want to add the following
custom key-value: `repository: https://github.com/somebody/myThirdPartyModule`

``` swift
public typealias Input = Compose<_Input, [String: StringCodable]>
```

### `Output`

The representation of a third party module. Used in the context rendered by the templates

``` swift
public typealias Output = Compose<_Output, [String: StringCodable]>
```

**TYPEALIAS**

# `ThirdPartyModule.Input`

```swift
public typealias Input = PartiallyTyped<_Input, [String: StringCodable]>
```

> The representation of a third party module, containing the typed and untyped properties.
> This allows to include custom keys-values in the third party modules, on top of the mandatory ones
> required by the typed representation. For example, you may want to add the following
> custom key-value: `repository: https://github.com/somebody/myThirdPartyModule`
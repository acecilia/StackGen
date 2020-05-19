# Types

  - [CleanAction](CleanAction.md):
    The action corresponting to the `clean` subcommand
  - [GenerateAction](GenerateAction.md):
    The action corresponting to the `generate` subcommand
  - [Context](Context.md):
    A namespace grouping the entities representing the context to be passed to the templates
  - [Context.Input](Context_Input.md):
    The initial representation of the context that will be passed to the templates
  - [Context.Middleware](Context_Middleware.md):
    A middleware representation of the context that will be passed to the templates
  - [Context.Output](Context_Output.md):
    The final representation of the context that will be passed to the templates
  - [Env](Env.md):
    An environment wrapper used to inject dependencies around without
    polluting the function signatures with multiple parameters
  - [FirstPartyModule](FirstPartyModule.md):
    A namespace grouping the entities representing a first party module
  - [FirstPartyModule.Input](FirstPartyModule_Input.md):
    A representation of a first party module to be used inside the stackgen.yml file
  - [FirstPartyModule.Output](FirstPartyModule_Output.md):
    A representation of a first party module that is used in the context
    rendered by the templates
  - [Global](Global.md):
    Global values to be injected in all template contexts
  - [ModuleKind](ModuleKind.md):
    The kind of module
  - [Options](Options.md):
    A namespace grouping the options passed to the tool
  - [Options.CLI](Options_CLI.md):
    The options that the tool accepts through the command line
  - [Options.StackGenFile](Options_StackGenFile.md):
    The options that the tool accepts through the stackgen.yml file
  - [Options.Resolved](Options_Resolved.md):
    The final options to be used during execution
  - [Path.Output](Path_Output.md):
    A path representation to be used when a path is needed inside the context
  - [StackGenFile](StackGenFile.md):
    The representation of the stackgen.yml file
  - [TemplateSpec](TemplateSpec.md):
    The specification for a template or a subdirectory of templates
  - [TemplateSpec.Mode](TemplateSpec_Mode.md):
    The mode that declares how a template is used
  - [ThirdPartyModule](ThirdPartyModule.md):
    A namespace grouping the entities representing a third party module
  - [ThirdPartyModule.\_Input](ThirdPartyModule__Input.md):
    The typed representation of a third party module
  - [ThirdPartyModule.\_Output](ThirdPartyModule__Output.md):
    The typed representation of a third party module. Used in the context rendered by the templates
  - [CustomError](CustomError.md):
    The errors thrown by the tool
  - [CustomError.Kind](CustomError_Kind.md):
    The kind of errors that the tool is expecing
  - [RegularExpression](RegularExpression.md):
    A wrapper around NSRegularExpression that can be encoded and decoded
  - [ModuleResolver](ModuleResolver.md):
    The service that resolves the modules specified in the stackgen.yml file
  - [Reporter](Reporter.md):
    The service used to format the prints
  - [Reporter.Emoji](Reporter_Emoji.md):
    The emojis to be used when printing
  - [StencilExtensions](StencilExtensions.md):
    The stencil filters to be used
  - [StencilFilter](StencilFilter.md):
    A namespace grouping the stencil filters
  - [StencilFilter.PathExists](StencilFilter_PathExists.md):
    An stencil filter to check when a path exists on disk
  - [StencilFilter.RelativeToRoot](StencilFilter_RelativeToRoot.md):
    An stencil filter that returns the path relative to the root of the repository
  - [StencilFilter.RelativeToModule](StencilFilter_RelativeToModule.md):
    An stencil filter that returns the path relative to the module being processed
  - [StencilFilter.Absolut](StencilFilter_Absolut.md):
    An stencil filter that returns the corresponding absolut path
  - [StencilFilter.ExpandDependencies](StencilFilter_ExpandDependencies.md):
    An stencil filter that expands a list of dependency names to their corresponding module dictionaries
  - [TemplateEngine](TemplateEngine.md):
    A wrapper around the template engine to use
  - [TemplateRenderer](TemplateRenderer.md):
    The service in charge of passing the context to the templates, render them
    and write them to disk
  - [TemplatesFileResolver](TemplatesFileResolver.md):
    The service in charge of resolving which templates file to use
  - [Writer](Writer.md):
    The service used to write files to disk

# Protocols

  - [StencilFilterInterface](StencilFilterInterface.md):
    An interface shared between all stencil filters

# Global Typealiases

  - [TemplatesFile](TemplatesFile.md):
    A representation of the content expected for the templates file

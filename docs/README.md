# Types

  - [CleanAction](CleanAction):
    The action corresponting to the `clean` subcommand
  - [GenerateAction](GenerateAction):
    The action corresponting to the `generate` subcommand
  - [Context](Context):
    A namespace grouping the entities representing the context to be passed to the templates
  - [Context.Input](Context_Input):
    The initial representation of the context that will be passed to the templates
  - [Context.Middleware](Context_Middleware):
    A middleware representation of the context that will be passed to the templates
  - [Context.Output](Context_Output):
    The final representation of the context that will be passed to the templates
  - [Env](Env):
    An environment wrapper used to inject dependencies around without
    polluting the function signatures with multiple parameters
  - [FirstPartyModule](FirstPartyModule):
    A namespace grouping the entities representing a first party module
  - [FirstPartyModule.Input](FirstPartyModule_Input):
    A representation of a first party module to be used inside the stackgen.yml file
  - [FirstPartyModule.Output](FirstPartyModule_Output):
    A representation of a first party module that is used in the context
    rendered by the templates
  - [Global](Global):
    Global values to be injected in all template contexts
  - [ModuleKind](ModuleKind):
    The kind of module
  - [Options](Options):
    A namespace grouping the options passed to the tool
  - [Options.CLI](Options_CLI):
    The options that the tool accepts through the command line
  - [Options.StackGenFile](Options_StackGenFile):
    The options that the tool accepts through the stackgen.yml file
  - [Options.Resolved](Options_Resolved):
    The final options to be used during execution
  - [Path.Output](Path_Output):
    A path representation to be used when a path is needed inside the context
  - [StackGenFile](StackGenFile):
    The representation of the stackgen.yml file
  - [TemplateSpec](TemplateSpec):
    The specification for a template or a subdirectory of templates
  - [TemplateSpec.Mode](TemplateSpec_Mode):
    The mode that declares how a template is used
  - [ThirdPartyModule](ThirdPartyModule):
    A namespace grouping the entities representing a third party module
  - [ThirdPartyModule.\_Input](ThirdPartyModule__Input):
    The typed representation of a third party module
  - [ThirdPartyModule.\_Output](ThirdPartyModule__Output):
    The typed representation of a third party module. Used in the context rendered by the templates
  - [CustomError](CustomError):
    The errors thrown by the tool
  - [CustomError.Kind](CustomError_Kind):
    The kind of errors that the tool is expecing
  - [RegularExpression](RegularExpression):
    A wrapper around NSRegularExpression that can be encoded and decoded
  - [ModuleResolver](ModuleResolver):
    The service that resolves the modules specified in the stackgen.yml file
  - [Reporter](Reporter):
    The service used to format the prints
  - [Reporter.Emoji](Reporter_Emoji):
    The emojis to be used when printing
  - [StencilExtensions](StencilExtensions):
    The stencil filters to be used
  - [StencilFilter](StencilFilter):
    A namespace grouping the stencil filters
  - [StencilFilter.PathExists](StencilFilter_PathExists):
    An stencil filter to check when a path exists on disk
  - [StencilFilter.RelativeToRoot](StencilFilter_RelativeToRoot):
    An stencil filter that returns the path relative to the root of the repository
  - [StencilFilter.RelativeToModule](StencilFilter_RelativeToModule):
    An stencil filter that returns the path relative to the module being processed
  - [StencilFilter.Absolut](StencilFilter_Absolut):
    An stencil filter that returns the corresponding absolut path
  - [StencilFilter.ExpandDependencies](StencilFilter_ExpandDependencies):
    An stencil filter that expands a list of dependency names to their corresponding module dictionaries
  - [TemplateEngine](TemplateEngine):
    A wrapper around the template engine to use
  - [TemplateRenderer](TemplateRenderer):
    The service in charge of passing the context to the templates, render them
    and write them to disk
  - [TemplatesFileResolver](TemplatesFileResolver):
    The service in charge of resolving which templates file to use
  - [Writer](Writer):
    The service used to write files to disk

# Protocols

  - [StencilFilterInterface](StencilFilterInterface):
    An interface shared between all stencil filters

# Global Typealiases

  - [TemplatesFile](TemplatesFile):
    A representation of the content expected for the templates file

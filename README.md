# StackGen

[![CI](https://github.com/acecilia/StackGen/workflows/CI/badge.svg?branch=master)](https://github.com/acecilia/StackGen/actions)
[![CI](https://codecov.io/gh/acecilia/StackGen/branch/master/graph/badge.svg)](https://codecov.io/github/acecilia/StackGen)

StackGen is a tool to generate and maintain your project stack. It works particulary well in monorepository projects that contain a high number of modules.

## The problem StackGen tries to solve

As a project grows, the number of developers working on it increases. The only feasible way of scaling in this scenario is to modularise the codebase. But this modularisation comes at a cost: **configuring**, **maintaining**, **building** and **connecting all of this modules together** becomes a challenge.

* **Configuring**: each module now has its own configuration that has to be created and maintained. Some examples are: the build settings, the linting configuration...
* **Maintaining**: keeping all the configuration aligned between modules is nearly impossible. Making configuration changes affecting all modules becomes a manual and tedious task. Some example are: modifying the lint rules, switching to a different build system... This can be even more complex if the developers working on each module are different: they will have their own way of writing code and setting up the module internally.
* **Building**: your build system should be able to support modules at different paths, generate IDE projects for each of them individually, and test all of them when pushing to CI. And it should do this in a reasonable amount of time.
* **Connecting all together**: your modules have dependencies between them and with third party modules. You will need to rely on a package manager that can integrate well with your build system and allows you to specify the relations between modules and their versions.

You get the idea: each module will contain multiple configuration files that will be very similar between each other, or the same.

## The solution: how StackGen works

StackGen is able to generate all the files in each module from a centralise place, so you have full control of their content. For example: in a project with 10 modules where each of them needs 4 configuration files, instead of having to maintain 40 files you will only need to maintain 4, and from them StackGen will be able to generate the 40 you need. To acomplish this it divides your project stack in two:

1. The `stackgen.yml` file: a configuration file that specifies your stack and modules at a high level, without any implementation details. For example, it includes:

    * Information shared between modules, such as the language version, the linter version...
    * Your modules: the path where they are located and the name of their dependencies. It does not include implementation details such as the build settings or the lint settings.
    * Your third party dependencies and their versions. It does not include implementation details such as which package manager to use for fetching and downloading them.

2. A bunch of templates: using the information stored in the `stackgen.yml` file they can generate all the configuration files needed by the modules. For example:

    * A package manager configuration file used to specify the dependencies of the module and their versions.
    * A linter configuration file that specify the lint rules.
    * Multiple script files to perform tasks on the module.

## Setup

In order to start using `StackGen` you will need two things:

1. The `stackgen.yml` file. The contents allowed inside it can be found [here](Documentation/Reference/structs/StackGenFile.md). Examples of it can be found [here](Examples/swift/stackgen.yml) and [here](stackgen.yml).
2. A bunch of templates. At the moment the only supported template language is [stencil](https://github.com/stencilproject/Stencil). StackGen comes with several groups of templates out of the box, which you can use as is or as a reference to create custom ones: find them [here](Templates). The context that is available from inside the templates is defined [here](Documentation/Reference/structs/Context.Output.md). In addition, there are several custom stencil filters available: [expand](Documentation/Reference/classes/StencilFilter.ExpandDependencies.md), [pathExists](Documentation/Reference/classes/StencilFilter.PathExists.md), [basename](Documentation/Reference/classes/StencilFilter.Basename.md), [parent](Documentation/Reference/classes/StencilFilter.Parent.md), [abs](Documentation/Reference/classes/StencilFilter.Absolut.md), [rm](Documentation/Reference/classes/StencilFilter.RelativeToModule.md) and [rr](Documentation/Reference/classes/StencilFilter.RelativeToRoot.md). Note that if the resulting file after rendering a template is empty, then the file will not be created.

## Installation

### Mint

Install the latest version globally by running the following command:

```shell
mint install acecilia/StackGen
```

## License

StackGen is licensed under the MIT license. See [LICENSE](LICENSE) for more information.
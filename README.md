# di_module

A Flutter package than can be used for DI.

### Reasons for creating this package
Provider is an excellent way to provide dependencies. However, when business logic gets more complex, taking care of providing and disposing multiple dependencies becomes complicated.

### How di_module could help
By creating per-page modules, providing multiple dependencies is easier. Dependencies are "bundled" into a module which when disposed, could dispose all of them.
Providing app-wide dependencies is easier as well since any dependency given to a parent is given to the child as well. This could prove useful for providing repositories for example.
Also, it is easier to know what kind of an instance you get of a dependency--either factory, which will create a new instance each time this dependency is requested, or singleton, which will give the same instance each time. Using singleton dependencies is helpful when a single instance is needed to keep track of changes in multiple places.

### How to use di_module
*Installing*
Add the following dependency to your pubspec.yaml:
```
di_module:
    git: https://github.com/plamenad-via/di_module
    ref: <latest version tag>

```

*Example*
See example in  [example directory](example/)

*Testing*

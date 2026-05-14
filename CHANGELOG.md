## [2.0.0]
* Breaking: replace `ModuleProvider<T>(module: ...)` with
  `ModuleProvider.create(createModule: ...)`.
* Fix `Provider<Module>` aliasing so rebuilds keep the typed module, generic
  module alias, parent lookup, and disposal lifecycle tied to one provider-owned
  instance.

## [1.2.0]
* Upgrade Dart to 3.0.0 and update dependencies. Enforce new linting file.

## [1.0.0]
* Initial Release

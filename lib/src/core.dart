import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class Module {
  Module() {
    provideInstances();
  }

  static const String _defaultQualifierName = 'defaultInstance';

  final _ServiceLocator _serviceLocator = _ServiceLocator();

  BuildContext? buildContext;

  ///Check each module on the tree recursively for an instance
  ///of [T]
  @protected
  T get<T>({
    String qualifierName = _defaultQualifierName,
    String? traversalPathConcat,
  }) {
    final result = _serviceLocator.get<T>(qualifierName: qualifierName);

    if (result != null) {
      return result;
    }

    final traversalPath = traversalPathConcat == null
        ? '$runtimeType'
        : '$traversalPathConcat -> $runtimeType';

    if (buildContext != null) {
      Module? parentModule;
      try {
        parentModule = ModuleProvider.of<Module>(buildContext!);
      } catch (_) {}

      if (parentModule != null) {
        return parentModule.get<T>(
          qualifierName: qualifierName,
          traversalPathConcat: traversalPath,
        );
      }
    }

    throw StateError(
      'No registered factory for instance of type '
      '$T and qualifier name $qualifierName. '
      'Looked in: $traversalPath',
    );
  }

  ///Provide an instance of [T] as a singleton
  ///
  ///[func] - the a function that will be used to provide instance of [T]
  ///
  ///[qualifierName] - the name that will be associated with this instance
  @protected
  void provideSingleton<T>(
    _FactoryFunction<T> func, {
    String qualifierName = _defaultQualifierName,
  }) =>
      _serviceLocator.registerSingleton<T>(func, qualifierName: qualifierName);

  ///Provide an instance of [T] by using a factory constructor
  ///
  ///[func] - the a function that will be used to provide instance of [T]
  ///
  ///[qualifierName] - the name that will be associated with this instance
  @protected
  void provideFactory<T>(
    _FactoryFunction<T> func, {
    String qualifierName = _defaultQualifierName,
  }) =>
      _serviceLocator.registerFactory<T>(func, qualifierName: qualifierName);

  @mustCallSuper
  void dispose() => _serviceLocator.clear();

  ///This method needs to be overridden in modules in order to provide
  ///dependencies as either factory or singleton
  void provideInstances();
}

class ModuleProvider<T extends Module> extends Provider<T> {
  ///Constructor of [ModuleProvider]
  ///
  ///[module] the [Module] that needs to be provided
  ///
  ///[child] the widget that will be built
  ModuleProvider({
    required this.module,
    Widget? child,
    super.key,
  }) : super(
          create: (buildContext) {
            module.buildContext = buildContext;
            return module;
          },
          dispose: (_, module) => module.dispose(),
          child: Provider<Module>.value(value: module, child: child),
          lazy: false,
        ) {
    if (T == Module) {
      throw StateError(
        'You forgot to pass a type to the '
        'ModelProvider<T>() constructor',
      );
    }
  }

  final T module;

  static T of<T>(BuildContext context, {bool listen = false}) =>
      Provider.of(context, listen: listen);
}

typedef _FactoryFunction<T> = T Function();

@immutable
class _Qualifier {
  const _Qualifier(this.type, this.name);

  final String name;
  final Type type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Qualifier &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type;

  @override
  int get hashCode => name.hashCode ^ type.hashCode;

  @override
  String toString() => 'Qualifier{name: $name, type: $type}';
}

class _ServiceLocator {
  final _serviceFactories = <_Qualifier, _ServiceFactory<dynamic>>{};

  T? get<T>({required String qualifierName}) {
    final serviceFactory = _serviceFactories[_Qualifier(T, qualifierName)];
    if (serviceFactory == null) {
      return null;
    }
    return serviceFactory.getInstance();
  }

  _Qualifier registerFactory<T>(
    _FactoryFunction<T> factoryFunction, {
    required String qualifierName,
  }) {
    _duplicationAssert(T, qualifierName);
    final qualifier = _Qualifier(T, qualifierName);
    _serviceFactories[qualifier] = _ServiceFactory<T>(
      _ServiceFactoryType.factory,
      creationFunction: factoryFunction,
    );

    return qualifier;
  }

  _Qualifier registerSingleton<T>(
    _FactoryFunction<T> singletonFactoryFunction, {
    required String qualifierName,
  }) {
    _duplicationAssert(T, qualifierName);
    final qualifier = _Qualifier(T, qualifierName);
    _serviceFactories[_Qualifier(T, qualifierName)] = _ServiceFactory<T>(
      _ServiceFactoryType.singleton,
      creationFunction: singletonFactoryFunction,
    );

    return qualifier;
  }

  void clear() => _serviceFactories.clear();

  void _duplicationAssert(Type type, String qualifierName) {
    assert(
      !_serviceFactories.containsKey(_Qualifier(type, qualifierName)),
      'The Type $type and qualifier name $qualifierName '
      'pair is already registered',
    );
  }
}

enum _ServiceFactoryType { factory, singleton }

class _ServiceFactory<T> {
  _ServiceFactory(this.type, {this.creationFunction, this.instance})
      : assert(
          (type == _ServiceFactoryType.factory && creationFunction != null) ||
              (type == _ServiceFactoryType.singleton &&
                  (creationFunction != null || instance != null)),
          'You need to provide either a [creationFunction] or [instance]',
        );

  final _ServiceFactoryType type;
  final _FactoryFunction? creationFunction;
  Object? instance;

  T getSingletonInstance() => instance as T;

  T getInstance() {
    try {
      switch (type) {
        case _ServiceFactoryType.factory:
          return creationFunction!() as T;
        case _ServiceFactoryType.singleton:
          instance ??= creationFunction!();
          return instance as T;
      }
    } catch (e, s) {
      log('Error while creating $T');
      log('Stack trace:\n $s');
      rethrow;
    }
  }
}

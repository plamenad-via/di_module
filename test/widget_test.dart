import 'package:di_module/src/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('ModuleProvider tests', () {
    testWidgets('Module gets disposed when ModuleProvider gets disposed',
        (widgetTester) async {
      final mockModule = MockModule();
      BuildContext innerContext;

      await widgetTester.pumpWidget(
        TestAppFrame(
          child: ModuleProvider<TestModule1>(
            module: mockModule,
            child: Builder(
              builder: (context) {
                innerContext = context;
                return Container();
              },
            ),
          ),
        ),
      );

      expect(ModuleProvider.of<TestModule1>(innerContext, listen: false),
          isNotNull);
      expect(ModuleProvider.of<Module>(innerContext, listen: false), isNotNull);

      await widgetTester.pumpWidget(
        TestAppFrame(child: Container()),
      );

      await untilCalled(mockModule.dispose());
    });

    testWidgets('Modules\' buildContext is null before attaching to tree',
        (widgetTester) async {
      final parentModule = ParentModule();
      final childModule = ChildModule();

      expect(parentModule.buildContext, isNull);
      expect(childModule.buildContext, isNull);
    });

    testWidgets(
        'ChildModule doesn\'t see ParentModule\'s dependencies until '
        'it is injected in a ModuleProvider lower in the tree '
        'from ParentModule\'s ModuleProvider', (widgetTester) async {
      final parentModule = ParentModule();
      final childModule = ChildModule();

      expect(parentModule.defaultStr, 'Hello');

      expect(
        () => childModule.firstString,
        throwsA(
          predicate((e) =>
              e is StateError &&
              e.message ==
                  'No registered factory for '
                      'instance of type String and qualifier name '
                      'defaultInstance. Looked in: ChildModule'),
        ),
      );
      expect(() => childModule.secondString, throwsStateError);
      expect(() => childModule.firstDouble, throwsStateError);
      expect(() => childModule.secondDouble, throwsStateError);
    });

    testWidgets('Context is not null when attached to tree',
        (widgetTester) async {
      final parentModule = ParentModule();
      final childModule = ChildModule();

      await widgetTester.pumpWidget(
        TestAppFrame(
          child: ModuleProvider(
            module: parentModule,
            child: ModuleProvider(
              module: childModule,
              child: Container(),
            ),
          ),
        ),
      );

      expect(parentModule.buildContext, isNotNull);
      expect(childModule.buildContext, isNotNull);
    });

    testWidgets('Modules\' dependency tree respects the Widget tree',
        (widgetTester) async {
      final parentModule = ParentModule();
      final childModule = ChildModule();

      await widgetTester.pumpWidget(
        TestAppFrame(
          child: ModuleProvider(
            module: parentModule,
            child: ModuleProvider(
              module: childModule,
              child: Container(),
            ),
          ),
        ),
      );
      expect(parentModule.defaultStr, 'Hello');

      expect(childModule.firstString, 'Hello, world');
      expect(childModule.secondString, 'Another hello, world');

      expect(childModule.firstDouble, 1.5);
      expect(childModule.secondDouble, 2.5);

      expect(
        () => childModule.notFoundBool,
        throwsA(
          predicate((e) =>
              e is StateError &&
              e.message ==
                  'No registered factory for '
                      'instance of type bool and qualifier name '
                      'defaultInstance. Looked in: ChildModule -> '
                      'ParentModule'),
        ),
      );
    });
  });
}

class TestAppFrame extends StatelessWidget {
  const TestAppFrame({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Test widget frame',
        theme: ThemeData(),
        home: child,
      );
}

//region Modules

class MockModule extends Mock implements TestModule1 {}

class TestModule1 extends Module {
  @override
  void provideInstances() {
    provideSingleton(() => 'hello');
  }
}

class ParentModule extends Module {
  String get defaultStr => get();

  @override
  void provideInstances() {
    provideFactory(() => 'Hello');
    provideFactory(() => 'Another hello', qualifierName: 'another');

    provideSingleton(() => 1.0);
    provideSingleton(() => 2.0, qualifierName: 'another');
  }
}

class ChildModule extends Module {
  String get firstString => get(qualifierName: 'childDefault');

  String get secondString => get(qualifierName: 'childAnother');

  double get firstDouble => get(qualifierName: 'childDefault');

  double get secondDouble => get(qualifierName: 'childAnother');

  bool get notFoundBool => get();

  @override
  void provideInstances() {
    provideFactory(() => '${get<String>()}, world',
        qualifierName: 'childDefault');
    provideFactory(() => '${get<String>(qualifierName: 'another')}, world',
        qualifierName: 'childAnother');

    provideSingleton(() => get<double>() + 0.5, qualifierName: 'childDefault');
    provideSingleton(() => get<double>(qualifierName: 'another') + 0.5,
        qualifierName: 'childAnother');
  }
}
//endregion Test Modules

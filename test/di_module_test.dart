import 'package:di_module/src/core.dart';
import 'package:flutter_test/flutter_test.dart';

late Module subjectModule;

void main() {
  group('Module unit tests', () {
    test('Module cannot provide same factory type with no qualifier name', () {
      expect(() => _TestModule1(), throwsAssertionError);
    });

    test(
        'Module cannot provide the same lazy singleton type without qualifier '
        'name', () {
      expect(() => _TestModule2(), throwsAssertionError);
    });

    test('Module can provide same type with a different qualifier name', () {
      final subject = _TestModule3();
      expect(subject.firstString, 'Hello');
      expect(subject.secondString, 'Another hello');

      expect(subject.firstDouble, 1.0);
      expect(subject.secondDouble, 2.0);
    });

    test(
        'Different modules can provide same types '
        'because they have different containers', () {
      _TestModule3();
      _TestModule4();
    });

    test('Lazy singleton returns same instance', () {
      final subject = _TestModule5();
      expect(identical(subject.testObject, subject.testObject), true);
    });

    test('Factory returns different instances', () {
      final subject = _TestModule6();
      expect(identical(subject.testObject, subject.testObject), false);
    });

    test('Lazy singleton with qualifier returns same instance', () {
      final subject = _TestModule7();
      expect(identical(subject.testObject, subject.testObject), true);
    });

    test('Factory with qualifier returns different instances', () {
      final subject = _TestModule8();
      expect(identical(subject.testObject, subject.testObject), false);
    });

    test(
        'Lazy singleton with qualifier returns different instances '
        'per different qualifiers', () {
      final subject = _TestModule7();
      expect(identical(subject.testObject, subject.anotherTestObject), false);
    });

    test(
        'Singleton with qualifier returns different instance '
        'per different qualifiers', () {
      final subject = _TestModule7();
      expect(identical(subject.testObject, subject.anotherTestObject), false);
    });

    test(
        'Factory with qualifier returns different instance '
        'per different qualifiers', () {
      final subject = _TestModule7();
      expect(identical(subject.testObject, subject.anotherTestObject), false);
    });

    test(
        'Dependencies of lazy singleton cannot be specified after '
        'registering it', () {
      final subject = _TestModule9();
      expect(subject.testObject, isNotNull);
    });
  });
}

//region TestModules
///Will provide 2 factory instances of [String] with no
///qualifier name
class _TestModule1 extends Module {
  @override
  void provideInstances() {
    provideFactory(() => 'Hello');
    provideFactory(() => 'Another hello');
  }
}

///Will provide 2 singleton instances of [double] with no
///qualifier name
class _TestModule2 extends Module {
  @override
  void provideInstances() {
    provideSingleton(() => 1.0);
    provideSingleton(() => 2.0);
  }
}

class _TestModule3 extends Module {
  String get firstString => get();

  String get secondString => get(qualifierName: 'another');

  double get firstDouble => get();

  double get secondDouble => get(qualifierName: 'another');

  @override
  void provideInstances() {
    provideFactory(() => 'Hello');
    provideFactory(() => 'Another hello', qualifierName: 'another');

    provideSingleton(() => 1.0);
    provideSingleton(() => 2.0, qualifierName: 'another');
  }
}

class _TestModule4 extends Module {
  String get firstString => get();

  String get secondString => get(qualifierName: 'another');

  int get firstInt => get();

  int get secondInt => get(qualifierName: 'another');

  double get firstDouble => get();

  double get secondDouble => get(qualifierName: 'another');

  @override
  void provideInstances() {
    provideFactory(() => 'Hello');
    provideFactory(() => 'Another hello', qualifierName: 'another');

    provideSingleton(() => 1.0);
    provideSingleton(() => 2.0, qualifierName: 'another');
  }
}

class _SimpleObject {
  _SimpleObject(this.name, this.count, this.price);

  final String name;
  final int count;
  final double price;
}

class _TestModule5 extends Module {
  _SimpleObject get testObject => get();

  @override
  void provideInstances() {
    provideSingleton(() => _SimpleObject('someName', 1, 2));
  }
}

class _TestModule6 extends Module {
  _SimpleObject get testObject => get();

  @override
  void provideInstances() {
    provideFactory(() => _SimpleObject('someName', 1, 2));
  }
}

class _TestModule7 extends Module {
  _SimpleObject get testObject => get(qualifierName: 'someQualifierName');

  _SimpleObject get anotherTestObject =>
      get(qualifierName: 'anotherQualifierName');

  @override
  void provideInstances() {
    provideSingleton(
      () => _SimpleObject('someName', 1, 2),
      qualifierName: 'someQualifierName',
    );
    provideSingleton(
      () => _SimpleObject('someName', 1, 2),
      qualifierName: 'anotherQualifierName',
    );
  }
}

class _TestModule8 extends Module {
  _SimpleObject get testObject => get(qualifierName: 'someQualifierName');

  _SimpleObject get anotherTestObject =>
      get(qualifierName: 'anotherQualifierName');

  @override
  void provideInstances() {
    provideFactory(
      () => _SimpleObject('someName', 1, 2),
      qualifierName: 'someQualifierName',
    );
    provideFactory(
      () => _SimpleObject('someName', 1, 2),
      qualifierName: 'anotherQualifierName',
    );
  }
}

class _TestModule9 extends Module {
  _SimpleObject get testObject => get();

  @override
  void provideInstances() {
    provideSingleton(() => _SimpleObject(get(), get(), get()));
    provideFactory(() => 'someName');
    provideFactory(() => 1);
    provideFactory(() => 2.0);
  }
}

//endregion TestModules

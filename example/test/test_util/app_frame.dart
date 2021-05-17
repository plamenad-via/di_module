import 'package:di_module/di_module.dart';
import 'package:example/base/api/sample_api.dart';
import 'package:example/base/di/app_module.dart';
import 'package:flutter/material.dart';

import 'mock_classes.dart';

class TestAppFrame extends StatelessWidget {
  const TestAppFrame({
    this.child,
    this.mockSampleApi,
  });

  final Widget? child;
  final SampleApi? mockSampleApi;

  @override
  Widget build(BuildContext context) => ModuleProvider<AppModule>(
        module: TestAppModule(
          mockSampleApi: mockSampleApi,
        ),
        child: MaterialApp(
          title: 'Test widget frame',
          theme: ThemeData(),
          home: ModuleProvider<AppModule>(
            module: TestAppModule(mockSampleApi: mockSampleApi),
            child: child,
          ),
        ),
      );
}

//Give a new [AppModule] in order to be able to use
//mock instances
class TestAppModule extends AppModule {
  TestAppModule({this.mockSampleApi});

  final SampleApi? mockSampleApi;

  @override
  void provideInstances() {
    provideSingleton<SampleApi>(() => mockSampleApi ?? MockSampleApi());
  }
}

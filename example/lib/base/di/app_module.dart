import 'package:di_module/di_module.dart';
import 'package:example/base/api/sample_api.dart';

///This is an app-wide module. All widgets have access to these instances
///through their context
class AppModule extends Module {
  @override
  void provideInstances() {
    provideSingleton(() => const SampleApi());
  }
}

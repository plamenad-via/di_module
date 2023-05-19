import 'package:di_module/di_module.dart';

import '../../base/repo/sample_repo.dart';

///This is a feature-specific module.
///It is provided only to HomePage and its descendants
class HomeModule extends Module {
  SampleRepository get sampleRepository => get();

  @override
  void provideInstances() {
    ///here the [SampleRepository] gets its [SampleApi]
    ///dependency from the AppModule
    provideSingleton(() => SampleRepository(get()));
  }
}

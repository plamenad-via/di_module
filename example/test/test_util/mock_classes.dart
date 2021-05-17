import 'package:example/base/api/sample_api.dart';
import 'package:mockito/mockito.dart';

import '../feature_home/home_page_test.dart';

class MockSampleApi extends Mock implements SampleApi {
  @override
  Future<String> getTitle() => Future.value(testTitle);
}

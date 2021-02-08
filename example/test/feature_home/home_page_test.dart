import 'package:di_module/di_module.dart';
import 'package:example/base/api/sample_api.dart';
import 'package:example/feature_home/di/home_module.dart';
import 'package:example/feature_home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_util/app_frame.dart';
import '../test_util/mock_classes.dart';

SampleApi _mockSampleApi = MockSampleApi();

void main() {
  const testTitle = 'Test title';

  setUp(() {
    //mock the response from [SampleApi]
    when(_mockSampleApi.getTitle()).thenAnswer((_) async => testTitle);
  });

  group('Home Page tests', () {
    testWidgets('Home page displays the correct content', (widgetTester) async {
      //push the relevant widget
      await _givenIAmOnTheHomePage(widgetTester);
      //give the Future time to finish and rebuild the view
      await widgetTester.pumpAndSettle();
      //find all widgets that have [testTitle] as text
      final textFind = find.text(testTitle);
      //verify that amount is as expected
      expect(textFind, findsNWidgets(2));
    });
  });
}

Future<void> _givenIAmOnTheHomePage(widgetTester) async =>
    await widgetTester.pumpWidget(_getSubjectWidget());

Widget _getSubjectWidget() => TestAppFrame(
      mockSampleApi: _mockSampleApi,
      child: ModuleProvider<HomeModule>(
        module: HomeModule(),
        child: const MyHomePage(),
      ),
    );

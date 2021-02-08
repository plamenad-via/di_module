import 'package:di_module/di_module.dart';
import 'package:example/base/di/app_module.dart';
import 'package:example/feature_home/di/home_module.dart';
import 'package:example/feature_home/view/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ModuleProvider(
        ///AppModule will be available to the whole app
        module: AppModule(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: ModuleProvider(
            module: HomeModule(),
            child: const MyHomePage(title: 'Flutter Demo Home Page'),
          ),
        ),
      );
}

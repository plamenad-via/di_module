import 'package:di_module/di_module.dart';
import 'package:flutter/material.dart';

import 'base/di/app_module.dart';
import 'feature_home/di/home_module.dart';
import 'feature_home/view/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

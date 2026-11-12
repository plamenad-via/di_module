import 'package:di_module/di_module.dart';
import 'package:material_ui/material_ui.dart';

import 'base/di/app_module.dart';
import 'feature_home/di/home_module.dart';
import 'feature_home/view/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ModuleProvider.create(
    ///AppModule will be available to the whole app
    createModule: () => AppModule(),
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ModuleProvider.create(
        createModule: () => HomeModule(),
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    ),
  );
}

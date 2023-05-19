import 'package:flutter/material.dart';

import '../../base/repo/sample_repo.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({this.title, super.key});

  final String? title;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: _buildTitle(context),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: _buildTitle(context),
              )
            ],
          ),
        ),
      );

  FutureBuilder<String> _buildTitle(BuildContext context) => FutureBuilder(
        initialData: title ?? '',
        //using repo directly for sake of
        //simplicity
        future: useSampleRepository(context).getTitle(),
        builder: (_, snapshot) => Text(snapshot.data ?? ''),
      );
}

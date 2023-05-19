import 'package:di_module/di_module.dart';
import 'package:flutter/material.dart';

import '../../feature_home/di/home_module.dart';
import '../api/sample_api.dart';

class SampleRepository {
  const SampleRepository(this._sampleApi);

  final SampleApi _sampleApi;

  Future<String> getTitle() => _sampleApi.getTitle();
}

///Exposing an easy access getter for [SampleRepository]
SampleRepository useSampleRepository(BuildContext context) =>
    ModuleProvider.of<HomeModule>(context).sampleRepository;

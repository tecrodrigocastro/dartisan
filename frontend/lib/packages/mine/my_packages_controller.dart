import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../data/package_api.dart';
import 'my_packages_state.dart';

class MyPackagesController extends ValueNotifier<MyPackagesState> {
  final PackageRepository _repository;

  MyPackagesController(this._repository) : super(const MyPackagesLoading());

  Future<void> load() async {
    value = const MyPackagesLoading();
    try {
      final packages = await _repository.getMine();
      value = MyPackagesLoaded(packages);
    } on ApiException catch (e) {
      value = MyPackagesFailure(e.message);
    }
  }
}

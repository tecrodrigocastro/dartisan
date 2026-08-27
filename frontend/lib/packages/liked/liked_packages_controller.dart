import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../data/package_api.dart';
import 'liked_packages_state.dart';

class LikedPackagesController extends ValueNotifier<LikedPackagesState> {
  final PackageRepository _repository;

  LikedPackagesController(this._repository) : super(const LikedPackagesLoading());

  Future<void> load() async {
    value = const LikedPackagesLoading();
    try {
      final packages = await _repository.getLikedByMe();
      value = LikedPackagesLoaded(packages);
    } on ApiException catch (e) {
      value = LikedPackagesFailure(e.message);
    }
  }
}

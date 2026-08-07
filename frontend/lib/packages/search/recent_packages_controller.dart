import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../data/package_api.dart';
import 'recent_packages_state.dart';

class RecentPackagesController extends ValueNotifier<RecentPackagesState> {
  final PackageRepository _repository;

  RecentPackagesController(this._repository) : super(const RecentPackagesLoading());

  Future<void> load() async {
    value = const RecentPackagesLoading();
    try {
      final list = await _repository.listRecent();
      value = RecentPackagesLoaded(list);
    } on ApiException catch (e) {
      value = RecentPackagesFailure(e.message);
    }
  }
}

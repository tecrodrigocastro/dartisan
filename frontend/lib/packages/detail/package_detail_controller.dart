import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../data/package_api.dart';
import 'package_detail_state.dart';

class PackageDetailController extends ValueNotifier<PackageDetailState> {
  final PackageRepository _repository;

  PackageDetailController(this._repository) : super(const PackageDetailLoading());

  Future<void> load(String name) async {
    value = const PackageDetailLoading();
    try {
      final metadata = await _repository.getMetadata(name);
      value = PackageDetailLoaded(metadata);
    } on ApiException catch (e) {
      value = e.code == 'not_found'
          ? PackageDetailNotFound(name)
          : PackageDetailFailure(e.message);
    } catch (e) {
      value = PackageDetailFailure(e.toString());
    }
  }
}

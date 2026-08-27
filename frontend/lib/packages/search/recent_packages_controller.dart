import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../data/package_api.dart';
import '../data/package_models.dart';
import 'recent_packages_state.dart';

class RecentPackagesController extends ValueNotifier<RecentPackagesState> {
  static const _pageSize = 12;

  final PackageRepository _repository;

  RecentPackagesController(this._repository) : super(const RecentPackagesLoading());

  Future<void> load() async {
    value = const RecentPackagesLoading();
    try {
      final list = await _repository.listRecent(limit: _pageSize, offset: 0);
      value = RecentPackagesLoaded(list);
    } on ApiException catch (e) {
      value = RecentPackagesFailure(e.message);
    }
  }

  Future<void> loadMore() async {
    final current = value;
    if (current is! RecentPackagesLoaded || current.loadingMore || !current.hasMore) {
      return;
    }

    value = RecentPackagesLoaded(current.list, loadingMore: true);
    try {
      final next = await _repository.listRecent(
        limit: _pageSize,
        offset: current.list.packages.length,
      );
      value = RecentPackagesLoaded(
        PackageList(
          packages: [...current.list.packages, ...next.packages],
          total: next.total,
        ),
      );
    } on ApiException catch (_) {
      // Falha ao paginar: volta pro estado anterior sem o spinner —
      // usuário pode tentar "carregar mais" de novo, sem perder a lista já carregada.
      value = RecentPackagesLoaded(current.list);
    }
  }
}

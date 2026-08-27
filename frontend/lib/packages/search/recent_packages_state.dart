import '../data/package_models.dart';

sealed class RecentPackagesState {
  const RecentPackagesState();
}

class RecentPackagesLoading extends RecentPackagesState {
  const RecentPackagesLoading();
}

class RecentPackagesLoaded extends RecentPackagesState {
  final PackageList list;
  final bool loadingMore;
  const RecentPackagesLoaded(this.list, {this.loadingMore = false});

  bool get hasMore => list.packages.length < list.total;
}

class RecentPackagesFailure extends RecentPackagesState {
  final String message;
  const RecentPackagesFailure(this.message);
}

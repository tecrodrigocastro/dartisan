import '../data/package_models.dart';

sealed class RecentPackagesState {
  const RecentPackagesState();
}

class RecentPackagesLoading extends RecentPackagesState {
  const RecentPackagesLoading();
}

class RecentPackagesLoaded extends RecentPackagesState {
  final PackageList list;
  const RecentPackagesLoaded(this.list);
}

class RecentPackagesFailure extends RecentPackagesState {
  final String message;
  const RecentPackagesFailure(this.message);
}

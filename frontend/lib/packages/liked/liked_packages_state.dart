import '../data/package_models.dart';

sealed class LikedPackagesState {
  const LikedPackagesState();
}

class LikedPackagesLoading extends LikedPackagesState {
  const LikedPackagesLoading();
}

class LikedPackagesLoaded extends LikedPackagesState {
  final List<PackageSummary> packages;
  const LikedPackagesLoaded(this.packages);
}

class LikedPackagesFailure extends LikedPackagesState {
  final String message;
  const LikedPackagesFailure(this.message);
}

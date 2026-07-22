import '../data/package_models.dart';

sealed class MyPackagesState {
  const MyPackagesState();
}

class MyPackagesLoading extends MyPackagesState {
  const MyPackagesLoading();
}

class MyPackagesLoaded extends MyPackagesState {
  final List<MyPackage> packages;
  const MyPackagesLoaded(this.packages);
}

class MyPackagesFailure extends MyPackagesState {
  final String message;
  const MyPackagesFailure(this.message);
}

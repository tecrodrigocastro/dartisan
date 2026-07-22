import '../data/package_models.dart';

sealed class PackageDetailState {
  const PackageDetailState();
}

class PackageDetailLoading extends PackageDetailState {
  const PackageDetailLoading();
}

class PackageDetailLoaded extends PackageDetailState {
  final PackageMetadata metadata;
  const PackageDetailLoaded(this.metadata);
}

class PackageDetailNotFound extends PackageDetailState {
  final String name;
  const PackageDetailNotFound(this.name);
}

class PackageDetailFailure extends PackageDetailState {
  final String message;
  const PackageDetailFailure(this.message);
}

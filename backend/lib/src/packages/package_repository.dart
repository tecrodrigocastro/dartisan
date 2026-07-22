import 'package:drift/drift.dart';
import 'package:vaden/vaden.dart';

import '../../config/drift/app_database.dart';

abstract class PackageRepository {
  Future<Package?> findByName(String name);
  Future<List<PackageVersion>> findVersions(String packageName);
  Future<PackageVersion?> findVersion(String packageName, String version);
}

@Repository()
class DriftPackageRepository implements PackageRepository {
  final AppDatabase _db;

  DriftPackageRepository(this._db);

  @override
  Future<Package?> findByName(String name) {
    return (_db.select(_db.packages)..where((p) => p.name.equals(name)))
        .getSingleOrNull();
  }

  @override
  Future<List<PackageVersion>> findVersions(String packageName) {
    return (_db.select(_db.packageVersions)
          ..where((v) => v.packageName.equals(packageName)))
        .get();
  }

  @override
  Future<PackageVersion?> findVersion(String packageName, String version) {
    return (_db.select(_db.packageVersions)..where(
          (v) => v.packageName.equals(packageName) & v.version.equals(version),
        ))
        .getSingleOrNull();
  }
}

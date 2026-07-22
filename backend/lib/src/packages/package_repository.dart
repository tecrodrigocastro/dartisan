import 'package:drift/drift.dart';
import 'package:vaden/vaden.dart';

import '../../config/drift/app_database.dart';

abstract class PackageRepository {
  Future<Package?> findByName(String name);
  Future<List<PackageVersion>> findVersions(String packageName);
  Future<PackageVersion?> findVersion(String packageName, String version);

  /// Insere a nova versão e atualiza (ou cria) o Package correspondente com
  /// [latestVersion] já recalculado — atômico, usado pelo publish (item 3).
  Future<void> saveNewVersion({
    required String packageName,
    required String version,
    required String pubspecYaml,
    required String archiveSha256,
    required String archivePath,
    required String latestVersion,
    int? uploaderTokenId,
  });
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

  @override
  Future<void> saveNewVersion({
    required String packageName,
    required String version,
    required String pubspecYaml,
    required String archiveSha256,
    required String archivePath,
    required String latestVersion,
    int? uploaderTokenId,
  }) {
    return _db.transaction(() async {
      await _db
          .into(_db.packages)
          .insertOnConflictUpdate(
            PackagesCompanion.insert(
              name: packageName,
              latestVersion: latestVersion,
            ),
          );

      await _db
          .into(_db.packageVersions)
          .insert(
            PackageVersionsCompanion.insert(
              packageName: packageName,
              version: version,
              pubspecYaml: pubspecYaml,
              archiveSha256: archiveSha256,
              archivePath: archivePath,
              uploaderTokenId: Value(uploaderTokenId),
            ),
          );
    });
  }
}

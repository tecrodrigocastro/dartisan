import 'package:drift/drift.dart';
import 'package:vaden/vaden.dart';

import '../../config/drift/app_database.dart';

abstract class PackageRepository {
  Future<Package?> findByName(String name);
  Future<List<PackageVersion>> findVersions(String packageName);
  Future<PackageVersion?> findVersion(String packageName, String version);

  /// Pacotes distintos com pelo menos uma versão enviada por [userId] — via
  /// PackageVersions.uploaderTokenId -> PublishTokens.userId.
  Future<List<Package>> findPackagesUploadedByUser(int userId);

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
  Future<List<Package>> findPackagesUploadedByUser(int userId) async {
    // selectOnly + addColumns pra selecionar só packageName — um SELECT com
    // join trazendo todas as colunas das 3 tabelas não passa no GROUP BY do
    // Postgres (toda coluna selecionada precisa estar agregada ou agrupada).
    final nameQuery =
        _db.selectOnly(_db.packageVersions)
          ..addColumns([_db.packageVersions.packageName])
          ..join([
            innerJoin(
              _db.publishTokens,
              _db.publishTokens.id.equalsExp(
                _db.packageVersions.uploaderTokenId,
              ),
            ),
          ])
          ..where(_db.publishTokens.userId.equals(userId))
          ..groupBy([_db.packageVersions.packageName]);

    final names = await nameQuery
        .map((row) => row.read(_db.packageVersions.packageName)!)
        .get();

    if (names.isEmpty) return [];

    return (_db.select(_db.packages)..where((p) => p.name.isIn(names))).get();
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

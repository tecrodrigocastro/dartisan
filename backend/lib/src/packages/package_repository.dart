import 'package:drift/drift.dart';
import 'package:vaden/vaden.dart';

import '../../config/drift/app_database.dart';

abstract class PackageRepository {
  Future<Package?> findByName(String name);
  Future<List<PackageVersion>> findVersions(String packageName);

  /// Como [findVersions], mas cada versão vem pareada com o username de quem
  /// publicou (null se o publish token que subiu a versão foi apagado, ou pra
  /// dados antigos sem uploaderTokenId).
  Future<List<(PackageVersion, String?)>> findVersionsWithUploader(
    String packageName,
  );

  Future<PackageVersion?> findVersion(String packageName, String version);

  /// Pacotes distintos com pelo menos uma versão enviada por [userId] — via
  /// PackageVersions.uploaderTokenId -> PublishTokens.userId.
  Future<List<Package>> findPackagesUploadedByUser(int userId);

  /// Os `limit` pacotes mais recentes (por `createdAt`), pra listagem pública.
  Future<List<Package>> listRecent({required int limit, required int offset});

  Future<int> countAll();

  /// Insere a nova versão e atualiza (ou cria) o Package correspondente com
  /// [latestVersion] já recalculado — atômico, usado pelo publish (item 3).
  /// [uploaderTokenId]/[uploaderUserId] nunca vêm os dois setados: publish
  /// via CLI usa o primeiro, import via GitHub (sem publish token) o segundo.
  Future<void> saveNewVersion({
    required String packageName,
    required String version,
    required String pubspecYaml,
    required String archiveSha256,
    required String archivePath,
    required String latestVersion,
    int? uploaderTokenId,
    int? uploaderUserId,
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
  Future<List<(PackageVersion, String?)>> findVersionsWithUploader(
    String packageName,
  ) async {
    // leftOuterJoin (não innerJoin) porque uploaderTokenId/uploaderUserId são
    // nullable e nunca os dois setados na mesma versão — uma versão sem
    // nenhum dos dois (ou com o token/usuário já apagado) ainda deve
    // aparecer, só sem uploader. Segundo alias de Users porque a tabela
    // entra no join duas vezes (via token e direto). Sem GROUP BY aqui,
    // então nenhum problema em selecionar todas as colunas (diferente do
    // que rolou em findPackagesUploadedByUser).
    final directUploader = _db.users.createAlias('direct_uploader');

    final query =
        _db.select(_db.packageVersions).join([
          leftOuterJoin(
            _db.publishTokens,
            _db.publishTokens.id.equalsExp(
              _db.packageVersions.uploaderTokenId,
            ),
          ),
          leftOuterJoin(
            _db.users,
            _db.users.id.equalsExp(_db.publishTokens.userId),
          ),
          leftOuterJoin(
            directUploader,
            directUploader.id.equalsExp(_db.packageVersions.uploaderUserId),
          ),
        ])..where(_db.packageVersions.packageName.equals(packageName));

    final rows = await query.get();
    return rows
        .map(
          (row) => (
            row.readTable(_db.packageVersions),
            row.readTableOrNull(_db.users)?.username ??
                row.readTableOrNull(directUploader)?.username,
          ),
        )
        .toList();
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
  Future<List<Package>> listRecent({required int limit, required int offset}) {
    return (_db.select(_db.packages)
          ..orderBy([(p) => OrderingTerm.desc(p.createdAt)])
          ..limit(limit, offset: offset))
        .get();
  }

  @override
  Future<int> countAll() async {
    // Packages não tem coluna `id` — a PK é `name` (ver app_database.dart).
    final count = _db.packages.name.count();
    final query = _db.selectOnly(_db.packages)..addColumns([count]);
    final row = await query.getSingle();
    return row.read(count) ?? 0;
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
    int? uploaderUserId,
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
              uploaderUserId: Value(uploaderUserId),
            ),
          );
    });
  }
}

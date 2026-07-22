import 'package:drift/drift.dart';
import 'package:vaden/vaden.dart';

import '../../config/drift/app_database.dart';

abstract class PublishTokenRepository {
  Future<PublishToken> insert({
    required int userId,
    required String tokenHash,
  });

  Future<List<PublishToken>> findByUserId(int userId);

  /// Retorna o token só se existir e não estiver revogado.
  Future<PublishToken?> findActiveByHash(String tokenHash);

  Future<void> touchLastUsed(int id);

  /// Só revoga se o token pertencer a [userId] — evita um usuário revogar
  /// token de outro. Retorna true se algo foi de fato revogado.
  Future<bool> revoke(int id, {required int userId});
}

@Repository()
class DriftPublishTokenRepository implements PublishTokenRepository {
  final AppDatabase _db;

  DriftPublishTokenRepository(this._db);

  @override
  Future<PublishToken> insert({
    required int userId,
    required String tokenHash,
  }) {
    return _db
        .into(_db.publishTokens)
        .insertReturning(
          PublishTokensCompanion.insert(userId: userId, tokenHash: tokenHash),
        );
  }

  @override
  Future<List<PublishToken>> findByUserId(int userId) {
    return (_db.select(
      _db.publishTokens,
    )..where((t) => t.userId.equals(userId))).get();
  }

  @override
  Future<PublishToken?> findActiveByHash(String tokenHash) async {
    final row = await (_db.select(
      _db.publishTokens,
    )..where((t) => t.tokenHash.equals(tokenHash))).getSingleOrNull();

    if (row == null || row.revokedAt != null) return null;
    return row;
  }

  @override
  Future<void> touchLastUsed(int id) {
    return (_db.update(_db.publishTokens)..where((t) => t.id.equals(id)))
        .write(PublishTokensCompanion(lastUsedAt: Value(DateTime.now())));
  }

  @override
  Future<bool> revoke(int id, {required int userId}) async {
    final updated = await (_db.update(_db.publishTokens)..where(
          (t) =>
              t.id.equals(id) &
              t.userId.equals(userId) &
              t.revokedAt.isNull(),
        )).write(PublishTokensCompanion(revokedAt: Value(DateTime.now())));
    return updated > 0;
  }
}

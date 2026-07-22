import 'package:drift/drift.dart';
import 'package:vaden/vaden.dart';

import '../../config/drift/app_database.dart';

abstract class RefreshTokenRepository {
  Future<void> insert({
    required int userId,
    required String tokenHash,
    required DateTime expiresAt,
  });

  /// Retorna o token só se existir, não estiver revogado e não tiver expirado.
  Future<RefreshToken?> findActiveByHash(String tokenHash);

  Future<void> revoke(int id);
}

@Repository()
class DriftRefreshTokenRepository implements RefreshTokenRepository {
  final AppDatabase _db;

  DriftRefreshTokenRepository(this._db);

  @override
  Future<void> insert({
    required int userId,
    required String tokenHash,
    required DateTime expiresAt,
  }) {
    return _db
        .into(_db.refreshTokens)
        .insert(
          RefreshTokensCompanion.insert(
            userId: userId,
            tokenHash: tokenHash,
            expiresAt: expiresAt,
          ),
        );
  }

  @override
  Future<RefreshToken?> findActiveByHash(String tokenHash) async {
    final row = await (_db.select(
      _db.refreshTokens,
    )..where((t) => t.tokenHash.equals(tokenHash))).getSingleOrNull();

    if (row == null) return null;
    if (row.revokedAt != null) return null;
    if (row.expiresAt.isBefore(DateTime.now())) return null;
    return row;
  }

  @override
  Future<void> revoke(int id) {
    return (_db.update(_db.refreshTokens)..where((t) => t.id.equals(id)))
        .write(RefreshTokensCompanion(revokedAt: Value(DateTime.now())));
  }
}

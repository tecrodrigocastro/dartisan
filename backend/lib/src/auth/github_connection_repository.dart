import 'package:drift/drift.dart';
import 'package:vaden/vaden.dart';

import '../../config/drift/app_database.dart';

abstract class GithubConnectionRepository {
  Future<void> upsert({
    required int userId,
    required String accessTokenEncrypted,
    String? refreshTokenEncrypted,
    DateTime? accessTokenExpiresAt,
  });

  Future<GithubConnection?> findByUserId(int userId);
}

@Repository()
class DriftGithubConnectionRepository implements GithubConnectionRepository {
  final AppDatabase _db;

  DriftGithubConnectionRepository(this._db);

  @override
  Future<void> upsert({
    required int userId,
    required String accessTokenEncrypted,
    String? refreshTokenEncrypted,
    DateTime? accessTokenExpiresAt,
  }) {
    return _db
        .into(_db.githubConnections)
        .insertOnConflictUpdate(
          GithubConnectionsCompanion.insert(
            userId: Value(userId),
            accessTokenEncrypted: accessTokenEncrypted,
            refreshTokenEncrypted: Value(refreshTokenEncrypted),
            accessTokenExpiresAt: Value(accessTokenExpiresAt),
          ),
        );
  }

  @override
  Future<GithubConnection?> findByUserId(int userId) {
    return (_db.select(
      _db.githubConnections,
    )..where((c) => c.userId.equals(userId))).getSingleOrNull();
  }
}

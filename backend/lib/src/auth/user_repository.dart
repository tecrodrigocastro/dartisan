import 'package:drift/drift.dart';
import 'package:vaden/vaden.dart';

import '../../config/drift/app_database.dart';

abstract class UserRepository {
  Future<User?> findByUsername(String username);
  Future<User?> findById(int id);
  Future<User?> findByGithubId(int githubId);

  /// Conta criada via login GitHub — sem senha local (`passwordHash` fica
  /// null), vinculada pelo `githubId`.
  Future<User> createGithubUser({
    required int githubId,
    required String username,
    required String role,
  });
}

@Repository()
class DriftUserRepository implements UserRepository {
  final AppDatabase _db;

  DriftUserRepository(this._db);

  @override
  Future<User?> findByUsername(String username) {
    return (_db.select(_db.users)..where((u) => u.username.equals(username)))
        .getSingleOrNull();
  }

  @override
  Future<User?> findById(int id) {
    return (_db.select(_db.users)..where((u) => u.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<User?> findByGithubId(int githubId) {
    return (_db.select(_db.users)..where((u) => u.githubId.equals(githubId)))
        .getSingleOrNull();
  }

  @override
  Future<User> createGithubUser({
    required int githubId,
    required String username,
    required String role,
  }) async {
    final id = await _db
        .into(_db.users)
        .insert(
          UsersCompanion.insert(
            username: username,
            role: role,
            githubId: Value(githubId),
          ),
        );
    return (await findById(id))!;
  }
}

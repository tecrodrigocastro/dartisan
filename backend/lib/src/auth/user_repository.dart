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

  /// Conta local (usuário + senha), com [passwordHash] já gerado pelo
  /// `PasswordEncoder` — usada pelo bootstrap do admin inicial.
  Future<User> createPasswordUser({
    required String username,
    required String passwordHash,
    required String role,
  });

  Future<List<User>> listAll();

  /// Retorna `false` se o usuário não existe.
  Future<bool> updateRole(int id, String role);
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

  @override
  Future<User> createPasswordUser({
    required String username,
    required String passwordHash,
    required String role,
  }) async {
    final id = await _db
        .into(_db.users)
        .insert(
          UsersCompanion.insert(
            username: username,
            role: role,
            passwordHash: Value(passwordHash),
          ),
        );
    return (await findById(id))!;
  }

  @override
  Future<List<User>> listAll() {
    return (_db.select(_db.users)..orderBy([(u) => OrderingTerm.asc(u.id)]))
        .get();
  }

  @override
  Future<bool> updateRole(int id, String role) async {
    final updated = await (_db.update(_db.users)..where((u) => u.id.equals(id)))
        .write(UsersCompanion(role: Value(role)));
    return updated > 0;
  }
}

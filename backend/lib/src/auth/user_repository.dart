import 'package:vaden/vaden.dart';

import '../../config/drift/app_database.dart';

abstract class UserRepository {
  Future<User?> findByUsername(String username);
  Future<User?> findById(int id);
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
}

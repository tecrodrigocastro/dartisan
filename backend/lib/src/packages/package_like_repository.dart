import 'package:drift/drift.dart';
import 'package:vaden/vaden.dart';

import '../../config/drift/app_database.dart';

abstract class PackageLikeRepository {
  /// Alterna o like do usuário nesse pacote — insere se não existir, remove
  /// se já existir. Retorna o novo estado (`true` = curtido agora).
  Future<bool> toggle(String packageName, int userId);

  Future<int> countFor(String packageName);

  Future<bool> isLikedBy(String packageName, int userId);

  /// Pacotes curtidos por [userId], mais recente primeiro — usado na aba
  /// "Curtidas" do perfil.
  Future<List<Package>> findLikedByUser(int userId);
}

@Repository()
class DriftPackageLikeRepository implements PackageLikeRepository {
  final AppDatabase _db;

  DriftPackageLikeRepository(this._db);

  @override
  Future<bool> toggle(String packageName, int userId) {
    return _db.transaction(() async {
      final existing = await (_db.select(_db.packageLikes)..where(
            (l) => l.packageName.equals(packageName) & l.userId.equals(userId),
          ))
          .getSingleOrNull();

      if (existing != null) {
        await (_db.delete(_db.packageLikes)..where(
              (l) => l.packageName.equals(packageName) & l.userId.equals(userId),
            ))
            .go();
        return false;
      }

      await _db
          .into(_db.packageLikes)
          .insert(
            PackageLikesCompanion.insert(packageName: packageName, userId: userId),
          );
      return true;
    });
  }

  @override
  Future<int> countFor(String packageName) async {
    final count = _db.packageLikes.packageName.count();
    final query = _db.selectOnly(_db.packageLikes)
      ..addColumns([count])
      ..where(_db.packageLikes.packageName.equals(packageName));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  @override
  Future<bool> isLikedBy(String packageName, int userId) async {
    final row = await (_db.select(_db.packageLikes)..where(
          (l) => l.packageName.equals(packageName) & l.userId.equals(userId),
        ))
        .getSingleOrNull();
    return row != null;
  }

  @override
  Future<List<Package>> findLikedByUser(int userId) async {
    final query =
        _db.select(_db.packageLikes).join([
          innerJoin(
            _db.packages,
            _db.packages.name.equalsExp(_db.packageLikes.packageName),
          ),
        ])
        ..where(_db.packageLikes.userId.equals(userId))
        ..orderBy([OrderingTerm.desc(_db.packageLikes.createdAt)]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(_db.packages)).toList();
  }
}

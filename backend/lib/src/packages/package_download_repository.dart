import 'package:drift/drift.dart';
import 'package:vaden/vaden.dart';

import '../../config/drift/app_database.dart';

class DownloadDay {
  /// 'yyyy-MM-dd', UTC.
  final String day;
  final int count;
  const DownloadDay({required this.day, required this.count});
}

abstract class PackageDownloadRepository {
  /// Incrementa a contagem de downloads do pacote pro dia de hoje (UTC).
  Future<void> recordDownload(String packageName);

  /// Contagem diária dos últimos [days] dias — dias sem download não geram
  /// linha (o chamador preenche os buracos com 0 ao montar o DTO).
  Future<List<DownloadDay>> dailyFor(String packageName, {int days = 30});

  Future<int> totalFor(String packageName);
}

@Repository()
class DriftPackageDownloadRepository implements PackageDownloadRepository {
  final AppDatabase _db;

  DriftPackageDownloadRepository(this._db);

  String _todayUtc() => DateTime.now().toUtc().toIso8601String().split('T').first;

  @override
  Future<void> recordDownload(String packageName) {
    final today = _todayUtc();
    return _db.transaction(() async {
      final existing = await (_db.select(_db.packageDownloadDaily)..where(
            (d) => d.packageName.equals(packageName) & d.day.equals(today),
          ))
          .getSingleOrNull();

      if (existing == null) {
        await _db
            .into(_db.packageDownloadDaily)
            .insert(
              PackageDownloadDailyCompanion.insert(
                packageName: packageName,
                day: today,
                count: const Value(1),
              ),
            );
        return;
      }

      await (_db.update(_db.packageDownloadDaily)..where(
            (d) => d.packageName.equals(packageName) & d.day.equals(today),
          ))
          .write(PackageDownloadDailyCompanion(count: Value(existing.count + 1)));
    });
  }

  @override
  Future<List<DownloadDay>> dailyFor(String packageName, {int days = 30}) async {
    // Filtro de intervalo em Dart, não em SQL — volume por pacote é pequeno
    // o suficiente pra isso não ser problema (ver comentário em app_database.dart
    // sobre por que `day` é TextColumn, não DateTimeColumn).
    final cutoff = DateTime.now().toUtc().subtract(Duration(days: days - 1));
    final cutoffDay = DateTime.utc(cutoff.year, cutoff.month, cutoff.day);

    final rows =
        await (_db.select(_db.packageDownloadDaily)
              ..where((d) => d.packageName.equals(packageName)))
            .get();

    return rows
        .where((r) => !DateTime.parse(r.day).isBefore(cutoffDay))
        .map((r) => DownloadDay(day: r.day, count: r.count))
        .toList();
  }

  @override
  Future<int> totalFor(String packageName) async {
    final total = _db.packageDownloadDaily.count.sum();
    final query = _db.selectOnly(_db.packageDownloadDaily)
      ..addColumns([total])
      ..where(_db.packageDownloadDaily.packageName.equals(packageName));
    final row = await query.getSingle();
    return row.read(total) ?? 0;
  }
}

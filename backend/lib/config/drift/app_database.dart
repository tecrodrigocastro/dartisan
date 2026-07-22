import 'package:drift/drift.dart';

part 'app_database.g.dart';

// Example table definition
// class Users extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get name => text().withLength(min: 1, max: 50)();
//   TextColumn get email => text().unique()();
//   DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
// }

@DriftDatabase(tables: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e, {bool logStatements = false});

  @override
  int get schemaVersion => 1;

  // Example migration
  // @override
  // MigrationStrategy get migration {
  //   return MigrationStrategy(
  //     onCreate: (Migrator m) async {
  //       await m.createAll();
  //     },
  //     onUpgrade: (Migrator m, int from, int to) async {
  //       // Run migration steps
  //     },
  //   );
  // }
}

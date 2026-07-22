import 'package:drift/drift.dart';

part 'app_database.g.dart';

class Packages extends Table {
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // Denormalizado para evitar ORDER BY em toda consulta de metadados.
  TextColumn get latestVersion => text()();

  @override
  Set<Column> get primaryKey => {name};
}

class PackageVersions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get packageName => text().references(Packages, #name)();
  // Semver como texto — comparação/ordenação feita via pub_semver, não lexicográfica.
  TextColumn get version => text()();
  TextColumn get pubspecYaml => text()();
  TextColumn get archiveSha256 => text()();
  TextColumn get archivePath => text()();
  DateTimeColumn get uploadedAt => dateTime().withDefault(currentDateAndTime)();
  // Nullable até o item 5 (autenticação) existir e popular essa coluna.
  TextColumn get uploaderTokenId => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {packageName, version},
  ];
}

@DriftDatabase(tables: [Packages, PackageVersions])
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

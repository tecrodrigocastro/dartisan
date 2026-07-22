import 'package:drift/drift.dart';

part 'app_database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  TextColumn get passwordHash => text()();
  // 'admin' | 'publisher' | 'reader' — ver docs/roadmap/05-autenticacao.md.
  TextColumn get role => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class RefreshTokens extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  // Nunca o token em texto puro — só o hash (sha256), igual senha.
  TextColumn get tokenHash => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get revokedAt => dateTime().nullable()();
}

class PublishTokens extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get tokenHash => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  DateTimeColumn get revokedAt => dateTime().nullable()();
}

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
  IntColumn get uploaderTokenId =>
      integer().nullable().references(PublishTokens, #id)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {packageName, version},
  ];
}

@DriftDatabase(
  tables: [Users, RefreshTokens, PublishTokens, Packages, PackageVersions],
)
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

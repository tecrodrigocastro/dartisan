import 'package:drift/drift.dart';

part 'app_database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  // Nullable: contas criadas via GitHub OAuth não têm senha local.
  TextColumn get passwordHash => text().nullable()();
  // 'admin' | 'publisher' | 'reader' — ver docs/roadmap/05-autenticacao.md.
  TextColumn get role => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // Id numérico do usuário no GitHub — presente só em contas criadas/vinculadas via OAuth.
  IntColumn get githubId => integer().nullable().unique()();
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
  // Atribuição direta ao usuário quando não existe publish token (import via
  // GitHub) — nunca setado junto com uploaderTokenId, só um dos dois.
  IntColumn get uploaderUserId => integer().nullable().references(Users, #id)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {packageName, version},
  ];
}

class PackageLikes extends Table {
  TextColumn get packageName => text().references(Packages, #name)();
  IntColumn get userId => integer().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {packageName, userId};
}

// Contagem de downloads por dia (UTC, truncado pra meia-noite) — granularidade
// suficiente pra um sparkline "últimos 30 dias" sem precisar de uma tabela de
// eventos individuais por download.
class PackageDownloadDaily extends Table {
  TextColumn get packageName => text().references(Packages, #name)();
  // Texto 'yyyy-MM-dd', não DateTimeColumn de propósito: comparação de
  // DateTimeColumn nesse setup drift+postgres compila pra `julianday()`
  // (função só do SQLite) mesmo pra igualdade simples — texto evita o
  // problema por completo, e o valor já vem normalizado no repository.
  TextColumn get day => text()();
  IntColumn get count => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {packageName, day};
}

// Token do GitHub (login social + import de repositório privado) por
// usuário — criptografado em repouso via TokenCipher (lib/src/auth/token_cipher.dart),
// nunca texto puro (diferente de senha/publish token, que são só hash porque
// nunca precisam ser lidos de volta; esse token precisa ser reenviado pro
// GitHub, então é criptografia reversível, não hash).
class GithubConnections extends Table {
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get accessTokenEncrypted => text()();
  TextColumn get refreshTokenEncrypted => text().nullable()();
  DateTimeColumn get accessTokenExpiresAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId};
}

@DriftDatabase(
  tables: [
    Users,
    RefreshTokens,
    PublishTokens,
    Packages,
    PackageVersions,
    PackageLikes,
    PackageDownloadDaily,
    GithubConnections,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e, {bool logStatements = false});

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // DDL no Postgres faz auto-commit por statement — não é atômico
          // como migração de schema no SQLite. Se o processo morrer no meio
          // (ou um passo falhar) e reiniciar, essa função roda de novo do
          // zero; cada passo checa se já foi aplicado antes de tentar de novo.
          if (!await _columnExists(m, 'users', 'github_id')) {
            await m.addColumn(users, users.githubId);
          }

          // `Migrator.alterTable`/`TableMigration` é a ferramenta de "rebuild"
          // do drift pro SQLite (usa PRAGMA por baixo) — não existe em
          // Postgres, único dialeto que esse projeto roda. DROP NOT NULL
          // direto é o jeito certo aqui, e já é idempotente (rodar de novo
          // numa coluna já nullable não dá erro).
          await m.database.customStatement(
            'ALTER TABLE users ALTER COLUMN password_hash DROP NOT NULL',
          );

          if (!await _tableExists(m, 'package_likes')) {
            await m.createTable(packageLikes);
          }
          if (!await _tableExists(m, 'package_download_daily')) {
            await m.createTable(packageDownloadDaily);
          }
        }

        if (from < 3) {
          if (!await _columnExists(m, 'package_versions', 'uploader_user_id')) {
            await m.addColumn(packageVersions, packageVersions.uploaderUserId);
          }
          if (!await _tableExists(m, 'github_connections')) {
            await m.createTable(githubConnections);
          }
        }
      },
    );
  }

  // `table`/`column` sempre vêm de literais internos (nunca input de usuário)
  // — interpolação direta é segura aqui, e evita um problema de bind de
  // parâmetro posicional (`?`) do customSelect com o driver postgres.
  Future<bool> _columnExists(Migrator m, String table, String column) async {
    final row = await m.database
        .customSelect(
          "SELECT 1 FROM information_schema.columns "
          "WHERE table_name = '$table' AND column_name = '$column'",
        )
        .getSingleOrNull();
    return row != null;
  }

  Future<bool> _tableExists(Migrator m, String table) async {
    final row = await m.database
        .customSelect(
          "SELECT 1 FROM information_schema.tables WHERE table_name = '$table'",
        )
        .getSingleOrNull();
    return row != null;
  }
}

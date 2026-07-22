import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:vaden/vaden.dart';

import 'app_database.dart';

@Configuration()
class DriftConfiguration {
  @Bean()
  AppDatabase appDatabase(
    pg.Connection postgresConnection,
    ApplicationSettings settings,
  ) {
    final logStatements = settings['drift']['log_statements'] == 'true';

    final connection = PgDatabase.opened(
      postgresConnection,
      logStatements: logStatements,
    );

    return AppDatabase(connection, logStatements: logStatements);
  }
}

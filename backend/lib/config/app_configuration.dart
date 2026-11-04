import 'package:vaden/vaden.dart';

import 'settings_guard.dart';

@Configuration()
class AppConfiguration {
  @Bean()
  ApplicationSettings settings() {
    final settings = ApplicationSettings.load('application.yaml');
    assertSafeSettings(
      mode: settings['env']['mode'] as String,
      securitySecret: settings['security']['secret'] as String,
      postgresPassword: settings['postgres']['password'] as String,
    );
    return settings;
  }

  @Bean()
  Pipeline globalMiddleware(ApplicationSettings settings) {
    return Pipeline() //
        .addMiddleware(cors(
          allowedOrigins: ['*'],
          allowHeaders: ['Origin', 'Content-Type', 'Accept', 'Authorization'],
        ))
        .addVadenMiddleware(EnforceJsonContentType())
        .addMiddleware(logRequests());
  }
}

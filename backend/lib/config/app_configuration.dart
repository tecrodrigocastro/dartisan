import 'package:vaden/vaden.dart';

@Configuration()
class AppConfiguration {
  @Bean()
  ApplicationSettings settings() {
    return ApplicationSettings.load('application.yaml');
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

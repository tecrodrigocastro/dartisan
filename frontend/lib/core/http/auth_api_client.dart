import 'package:dio/dio.dart';

import 'api_base_url.dart';

/// Dio dedicado aos endpoints de `/api/auth/*` (login/refresh/logout) — sem
/// interceptors, porque nenhum desses endpoints exige Authorization e o
/// próprio `refresh` é usado pelo interceptor de retry de [ApiClient], que
/// não pode chamar a si mesmo.
class AuthApiClient {
  final Dio dio;

  AuthApiClient() : dio = Dio(BaseOptions(baseUrl: apiBaseUrl));
}

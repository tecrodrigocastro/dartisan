import 'package:dio/dio.dart';

import '../../auth/data/auth_api.dart';
import '../session/app_session.dart';
import '../storage/token_storage.dart';
import 'api_base_url.dart';

/// Dio autenticado usado por tudo além de `/api/auth/*` (pacotes, publish
/// tokens). Injeta `Authorization: Bearer <access_token>` e, num 401, tenta
/// renovar a sessão uma vez via [AuthApi.refresh] antes de repetir a request.
class ApiClient {
  final Dio dio;

  ApiClient(TokenStorage storage, AuthApi authApi, AppSession session)
    : dio = Dio(BaseOptions(baseUrl: apiBaseUrl)) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await storage.readAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final alreadyRetried = error.requestOptions.extra['retried'] == true;
          if (error.response?.statusCode != 401 || alreadyRetried) {
            handler.next(error);
            return;
          }

          final refreshToken = await storage.readRefreshToken();
          if (refreshToken == null) {
            handler.next(error);
            return;
          }

          try {
            final tokens = await authApi.refresh(refreshToken);
            await session.onTokensRefreshed(tokens);

            final retryOptions = error.requestOptions;
            retryOptions.extra['retried'] = true;
            retryOptions.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
            final response = await dio.fetch(retryOptions);
            handler.resolve(response);
          } catch (_) {
            await session.clear();
            handler.next(error);
          }
        },
      ),
    );
  }
}

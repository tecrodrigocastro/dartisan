import 'package:flutter_modular/flutter_modular.dart';

import '../auth/data/auth_api.dart';
import '../packages/data/package_api.dart';
import '../tokens/data/publish_token_api.dart';
import 'http/api_client.dart';
import 'http/auth_api_client.dart';
import 'session/app_session.dart';
import 'storage/token_storage.dart';

/// Sem `path` → shared DI, root-owned (nunca disposed). É aqui que vive a
/// fonte da verdade: storage, clients HTTP, repositórios e a sessão.
final coreModule = createModule(
  register: (c) {
    c
      ..addSingleton<TokenStorage>(TokenStorage.new)
      ..addSingleton<AuthApiClient>(AuthApiClient.new)
      ..addSingleton<AuthApi>(AuthApi.new)
      ..addSingleton<AppSession>(AppSession.new)
      ..addSingleton<ApiClient>(ApiClient.new)
      ..addSingleton<PackageRepository>(PackageRepository.new)
      ..addSingleton<PublishTokenRepository>(PublishTokenRepository.new);
  },
);

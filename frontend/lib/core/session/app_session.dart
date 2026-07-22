import 'package:flutter/foundation.dart';

import '../../auth/data/auth_api.dart';
import '../../auth/data/auth_models.dart';
import '../jwt/jwt_decoder.dart';
import '../storage/token_storage.dart';
import 'session_state.dart';

/// Fonte da verdade da sessão — singleton root-owned (ver core_module.dart).
/// `ValueNotifier<SessionState>` é lido por guards via `inject<AppSession>()`
/// e pela UI (barra superior) via `inject<AppSession>()` + `ValueListenableBuilder`
/// — nunca via `context.watch`, ver decisão #3 do plano.
class AppSession extends ValueNotifier<SessionState> {
  final TokenStorage _storage;
  final AuthApi _authApi;

  AppSession(this._storage, this._authApi) : super(const SessionUnknown());

  /// Chamado uma vez em `main()` antes do `runApp`. Tenta restaurar a sessão
  /// persistida; expirada mas com refresh token presente, tenta 1 refresh.
  Future<void> restore() async {
    final accessToken = await _storage.readAccessToken();
    final refreshToken = await _storage.readRefreshToken();

    if (accessToken == null || refreshToken == null) {
      value = const SessionUnauthenticated();
      return;
    }

    final claims = JwtClaims.decode(accessToken);
    if (!claims.isExpired) {
      value = SessionAuthenticated(
        username: claims.subject ?? '',
        roles: claims.roles,
      );
      return;
    }

    try {
      final tokens = await _authApi.refresh(refreshToken);
      await _applyTokens(tokens);
    } catch (_) {
      await _storage.clear();
      value = const SessionUnauthenticated();
    }
  }

  Future<void> onLoginSuccess(Tokenization tokens) => _applyTokens(tokens);

  /// Usado pelo interceptor de [ApiClient] quando um refresh automático
  /// (após 401) dá certo, pra manter a sessão em sincronia.
  Future<void> onTokensRefreshed(Tokenization tokens) => _applyTokens(tokens);

  Future<void> logout() async {
    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken != null) {
      try {
        await _authApi.logout(refreshToken);
      } catch (_) {
        // Best-effort — a sessão local é limpa de qualquer forma.
      }
    }
    await _storage.clear();
    value = const SessionUnauthenticated();
  }

  /// Usado pelo interceptor de [ApiClient] quando o refresh automático falha.
  Future<void> clear() async {
    await _storage.clear();
    value = const SessionUnauthenticated();
  }

  Future<void> _applyTokens(Tokenization tokens) async {
    await _storage.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
    final claims = JwtClaims.decode(tokens.accessToken);
    value = SessionAuthenticated(
      username: claims.subject ?? '',
      roles: claims.roles,
    );
  }
}

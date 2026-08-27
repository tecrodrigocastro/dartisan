import 'package:vaden/vaden.dart';

import 'github_connection_repository.dart';
import 'github_oauth_client.dart';
import 'token_cipher.dart';

@Service()
class GithubConnectionService {
  final GithubConnectionRepository _repository;
  final GithubOAuthClient _client;
  final TokenCipher _cipher;

  GithubConnectionService(this._repository, this._client, this._cipher);

  Future<void> save(int userId, GithubTokenSet tokens) async {
    await _repository.upsert(
      userId: userId,
      accessTokenEncrypted: await _cipher.encryptToken(tokens.accessToken),
      refreshTokenEncrypted: tokens.refreshToken == null
          ? null
          : await _cipher.encryptToken(tokens.refreshToken!),
      accessTokenExpiresAt: tokens.expiresIn == null
          ? null
          : DateTime.now().add(tokens.expiresIn!),
    );
  }

  Future<bool> isConnected(int userId) async {
    return await _repository.findByUserId(userId) != null;
  }

  /// Devolve um access token válido, renovando via refresh token se
  /// necessário. Lança 400 se o usuário nunca conectou o GitHub ou se a
  /// conexão expirou de vez (sem refresh token pra renovar).
  Future<String> getValidAccessToken(int userId) async {
    final connection = await _repository.findByUserId(userId);
    if (connection == null) {
      throw ResponseException.badRequest({
        'error': {
          'code': 'github_not_connected',
          'message': 'Conecte sua conta do GitHub antes de importar um repositório',
        },
      });
    }

    final expiresAt = connection.accessTokenExpiresAt;
    // Margem de 1 min pra não usar um token que expira no meio da requisição.
    final isExpired =
        expiresAt != null &&
        expiresAt.isBefore(DateTime.now().add(const Duration(minutes: 1)));

    if (!isExpired) {
      return _cipher.decryptToken(connection.accessTokenEncrypted);
    }

    final refreshTokenEncrypted = connection.refreshTokenEncrypted;
    if (refreshTokenEncrypted == null) {
      throw ResponseException.badRequest({
        'error': {
          'code': 'github_token_expired',
          'message': 'Sua conexão com o GitHub expirou — conecte de novo',
        },
      });
    }

    final refreshToken = await _cipher.decryptToken(refreshTokenEncrypted);
    final refreshed = await _client.refreshAccessToken(refreshToken);
    await save(userId, refreshed);
    return refreshed.accessToken;
  }
}

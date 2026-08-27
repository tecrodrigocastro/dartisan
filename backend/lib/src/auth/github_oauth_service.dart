import 'package:vaden/vaden.dart';
import 'package:vaden_security/vaden_security.dart';

import 'app_user_details.dart';
import 'auth_service.dart';
import 'github_connection_service.dart';
import 'github_oauth_client.dart';
import 'oauth_state_store.dart';
import 'user_repository.dart';

sealed class GithubCallbackResult {
  const GithubCallbackResult();
}

/// Fluxo "conectar": token vinculado à conta que já estava logada, sem
/// login/troca de conta nenhuma.
class GithubCallbackConnected extends GithubCallbackResult {
  const GithubCallbackConnected();
}

/// Fluxo "login": usuário resolvido (achado ou criado), tokens Dartisan já
/// emitidos e guardados sob um código de troca de uso único.
class GithubCallbackLoggedIn extends GithubCallbackResult {
  final String exchangeCode;
  const GithubCallbackLoggedIn(this.exchangeCode);
}

@Service()
class GithubOAuthService {
  final GithubOAuthClient _client;
  final OAuthStateStore _stateStore;
  final UserRepository _users;
  final AuthService _authService;
  final GithubConnectionService _connections;

  GithubOAuthService(
    this._client,
    this._stateStore,
    this._users,
    this._authService,
    this._connections,
  );

  String startLogin(String redirectUri) {
    final state = _stateStore.createState();
    return _client.buildAuthorizeUrl(state: state, redirectUri: redirectUri);
  }

  /// Igual ao login, mas o `state` carrega o usuário já logado — o callback
  /// não cria/troca de conta, só vincula o token do GitHub à conta atual.
  String startConnect(String redirectUri, int userId) {
    final state = _stateStore.createState(forUserId: userId);
    return _client.buildAuthorizeUrl(state: state, redirectUri: redirectUri);
  }

  /// Processa o callback do GitHub — troca o `code`, e então ramifica em
  /// "conectar" (state carregava um userId) ou "login" (acha/cria usuário
  /// pelo githubId, emite tokens Dartisan).
  Future<GithubCallbackResult> handleCallback({
    required String? code,
    required String? state,
    required String redirectUri,
  }) async {
    if (code == null || state == null) {
      throw _invalidState;
    }

    final consumed = _stateStore.consumeState(state);
    if (!consumed.valid) {
      throw _invalidState;
    }

    final tokens = await _client.exchangeCodeForAccessToken(
      code: code,
      redirectUri: redirectUri,
    );
    final profile = await _client.fetchProfile(tokens.accessToken);

    final forUserId = consumed.forUserId;
    if (forUserId != null) {
      await _connections.save(forUserId, tokens);
      return const GithubCallbackConnected();
    }

    var user = await _users.findByGithubId(profile.id);
    if (user == null) {
      var username = profile.login;
      if (await _users.findByUsername(username) != null) {
        username = '${profile.login}-${profile.id}';
      }
      // 'reader' por padrão — um admin promove manualmente pra 'publisher'
      // antes da pessoa conseguir publicar (ver docs/roadmap/05-autenticacao.md).
      user = await _users.createGithubUser(
        githubId: profile.id,
        username: username,
        role: 'reader',
      );
    }
    await _connections.save(user.id, tokens);

    final dartisanTokens = await _authService.issueTokensFor(
      AppUserDetails(id: user.id, username: user.username, password: '', roles: [user.role]),
    );

    return GithubCallbackLoggedIn(_stateStore.createExchangeCode(dartisanTokens));
  }

  /// Troca o código de uso único (devolvido no redirect pro frontend) pelos
  /// tokens de verdade.
  Tokenization exchangeCode(String code) {
    final tokens = _stateStore.consumeExchangeCode(code);
    if (tokens == null) {
      throw ResponseException.badRequest({
        'error': {
          'code': 'invalid_code',
          'message': 'Código de login expirado ou já usado',
        },
      });
    }
    return tokens;
  }

  static final _invalidState = ResponseException.badRequest({
    'error': {
      'code': 'invalid_oauth_state',
      'message': 'Login GitHub inválido ou expirado',
    },
  });
}

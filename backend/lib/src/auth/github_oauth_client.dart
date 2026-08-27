import 'package:dio/dio.dart';
// `Options` existe tanto em dio quanto em vaden (anotação de rota) — escondido
// daqui porque só o de dio (configuração de request HTTP) é usado neste arquivo.
import 'package:vaden/vaden.dart' hide Options;

class GithubProfile {
  final int id;
  final String login;
  final String? email;

  const GithubProfile({required this.id, required this.login, required this.email});
}

/// Par access/refresh token do GitHub. `refreshToken`/`expiresIn` só vêm
/// preenchidos porque o OAuth App tem "Expire user access tokens" ligado —
/// sem isso o GitHub devolve só um access_token sem expiração.
class GithubTokenSet {
  final String accessToken;
  final String? refreshToken;
  final Duration? expiresIn;

  const GithubTokenSet({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });
}

class GithubRepo {
  final String owner;
  final String name;
  final String fullName;
  final bool private;

  const GithubRepo({
    required this.owner,
    required this.name,
    required this.fullName,
    required this.private,
  });
}

// Cliente próprio (não o Dio bean existente em dio_configuration.dart, que
// aponta pro base_url do próprio backend) — esse aqui fala com github.com e
// api.github.com, hosts externos, então não faz sentido compartilhar o bean.
@Component()
class GithubOAuthClient {
  final ApplicationSettings _settings;
  final Dio _dio = Dio();

  GithubOAuthClient(this._settings);

  String get _clientId => _settings['security']['github']['client_id'] as String;
  String get _clientSecret =>
      _settings['security']['github']['client_secret'] as String;

  String buildAuthorizeUrl({required String state, required String redirectUri}) {
    final uri = Uri.https('github.com', '/login/oauth/authorize', {
      'client_id': _clientId,
      'redirect_uri': redirectUri,
      // `repo` é necessário pra ler conteúdo de repositório privado no fluxo
      // de import (ver github_import_service.dart) — o GitHub não tem um
      // escopo mais estreito de "só leitura" pra OAuth App clássico.
      'scope': 'read:user user:email repo',
      'state': state,
    });
    return uri.toString();
  }

  Future<GithubTokenSet> exchangeCodeForAccessToken({
    required String code,
    required String redirectUri,
  }) {
    return _requestTokenSet({
      'client_id': _clientId,
      'client_secret': _clientSecret,
      'code': code,
      'redirect_uri': redirectUri,
    });
  }

  Future<GithubTokenSet> refreshAccessToken(String refreshToken) {
    return _requestTokenSet({
      'client_id': _clientId,
      'client_secret': _clientSecret,
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    });
  }

  Future<GithubTokenSet> _requestTokenSet(Map<String, dynamic> data) async {
    final response = await _dio.post(
      'https://github.com/login/oauth/access_token',
      data: data,
      options: Options(headers: {'Accept': 'application/json'}),
    );

    final body = response.data as Map;
    final accessToken = body['access_token'] as String?;
    if (accessToken == null) {
      throw ResponseException.badRequest({
        'error': {
          'code': 'github_oauth_failed',
          'message': 'Não foi possível autenticar com o GitHub',
        },
      });
    }

    final expiresIn = body['expires_in'] as int?;
    return GithubTokenSet(
      accessToken: accessToken,
      refreshToken: body['refresh_token'] as String?,
      expiresIn: expiresIn == null ? null : Duration(seconds: expiresIn),
    );
  }

  Future<GithubProfile> fetchProfile(String accessToken) async {
    final headers = _authHeaders(accessToken);

    final userResponse = await _dio.get(
      'https://api.github.com/user',
      options: Options(headers: headers),
    );
    final data = userResponse.data as Map<String, dynamic>;

    var email = data['email'] as String?;
    if (email == null) {
      // E-mail primário privado nos dados do perfil — precisa do endpoint
      // dedicado (exige o scope `user:email`, já pedido no authorize).
      final emailsResponse = await _dio.get(
        'https://api.github.com/user/emails',
        options: Options(headers: headers),
      );
      final emails = (emailsResponse.data as List).cast<Map<String, dynamic>>();
      final primary = emails.where((e) => e['primary'] == true && e['verified'] == true);
      email = primary.isEmpty ? null : primary.first['email'] as String?;
    }

    return GithubProfile(
      id: data['id'] as int,
      login: data['login'] as String,
      email: email,
    );
  }

  /// Repositórios que o usuário tem acesso (próprios, colaborador, ou de
  /// organização) — só a primeira página (100, mais recentes primeiro).
  /// Paginação fica pra quando/se alguém precisar de mais que isso.
  Future<List<GithubRepo>> listRepos(String accessToken) async {
    final response = await _dio.get(
      'https://api.github.com/user/repos',
      queryParameters: {
        'per_page': 100,
        'sort': 'updated',
        'affiliation': 'owner,collaborator,organization_member',
      },
      options: Options(headers: _authHeaders(accessToken)),
    );

    return (response.data as List).cast<Map<String, dynamic>>().map((repo) {
      final owner = repo['owner'] as Map<String, dynamic>;
      return GithubRepo(
        owner: owner['login'] as String,
        name: repo['name'] as String,
        fullName: repo['full_name'] as String,
        private: repo['private'] as bool,
      );
    }).toList();
  }

  Future<List<String>> listBranches(String accessToken, String owner, String repo) {
    return _listRefNames(accessToken, 'https://api.github.com/repos/$owner/$repo/branches');
  }

  Future<List<String>> listTags(String accessToken, String owner, String repo) {
    return _listRefNames(accessToken, 'https://api.github.com/repos/$owner/$repo/tags');
  }

  Future<List<String>> _listRefNames(String accessToken, String url) async {
    final response = await _dio.get(
      url,
      queryParameters: {'per_page': 100},
      options: Options(headers: _authHeaders(accessToken)),
    );
    return (response.data as List)
        .cast<Map<String, dynamic>>()
        .map((ref) => ref['name'] as String)
        .toList();
  }

  Future<List<int>> downloadTarball(
    String accessToken,
    String owner,
    String repo,
    String ref,
  ) async {
    final response = await _dio.get<List<int>>(
      'https://api.github.com/repos/$owner/$repo/tarball/$ref',
      options: Options(
        headers: _authHeaders(accessToken),
        responseType: ResponseType.bytes,
      ),
    );
    return response.data!;
  }

  Map<String, String> _authHeaders(String accessToken) => {
    'Authorization': 'Bearer $accessToken',
    'Accept': 'application/vnd.github+json',
  };
}

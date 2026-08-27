import 'package:vaden/vaden.dart';
import 'package:vaden_security/vaden_security.dart';

import 'auth_dto.dart';
import 'github_oauth_service.dart';

@Api(tag: 'Auth', description: 'Login via GitHub OAuth')
@Controller('/api/auth/github')
class GithubOAuthController {
  final GithubOAuthService _service;
  final ApplicationSettings _settings;

  GithubOAuthController(this._service, this._settings);

  String get _redirectUri =>
      '${_settings['env']['base_url']}/api/auth/github/callback';

  String get _frontendUrl => _settings['env']['frontend_url'] as String;

  @Get('/login')
  Future<Response> login() async {
    final url = _service.startLogin(_redirectUri);
    return Response.found(url);
  }

  // Navegação de browser (não XHR) — em erro, redireciona de volta pro
  // frontend com um indicador em vez de devolver um JSON de erro cru na tela.
  // Atende tanto o fluxo de login quanto o de conectar (GithubConnectController)
  // — os dois usam essa mesma callback URL, que é a única registrada no
  // OAuth App do GitHub.
  @Get('/callback')
  Future<Response> callback(
    @Query('code') String? code,
    @Query('state') String? state,
  ) async {
    try {
      final result = await _service.handleCallback(
        code: code,
        state: state,
        redirectUri: _redirectUri,
      );
      return switch (result) {
        GithubCallbackConnected() => Response.found('$_frontendUrl/profile?github=connected'),
        GithubCallbackLoggedIn(:final exchangeCode) => Response.found(
          '$_frontendUrl/login/github/callback?code=$exchangeCode',
        ),
      };
    } catch (_) {
      return Response.found('$_frontendUrl/login?error=github_oauth_failed');
    }
  }

  @Post('/exchange')
  Tokenization exchange(@Body() GithubExchangeRequestDTO body) {
    return _service.exchangeCode(body.code);
  }
}

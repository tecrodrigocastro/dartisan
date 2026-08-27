import 'package:vaden/vaden.dart';

import 'app_user_details.dart';
import 'github_oauth_service.dart';

// Sob /api/github (não /api/auth/github) de propósito: '/api/auth/**' é
// público (SecurityConfiguration), e essa rota PRECISA de sessão — é ela que
// decide a quem vincular o token do GitHub. Fora desse prefixo cai
// naturalmente no catch-all AnyRequest().authenticated(), sem precisar de
// exceção na regra de segurança.
@Api(
  tag: 'Github',
  description: 'Vincula a conta do GitHub ao usuário autenticado (sem criar/trocar de conta)',
)
@Controller('/api/github')
class GithubConnectController {
  final GithubOAuthService _service;
  final ApplicationSettings _settings;

  GithubConnectController(this._service, this._settings);

  String get _redirectUri =>
      '${_settings['env']['base_url']}/api/auth/github/callback';

  // Devolve a URL em vez de um 302: essa rota exige o header Authorization
  // (Bearer JWT), que só o cliente HTTP autenticado do frontend consegue
  // anexar — uma navegação de página inteira (window.location) não tem como
  // mandar header nenhum. O frontend busca a URL via XHR autenticado e só
  // então navega o browser pra ela.
  @Get('/connect')
  Future<Map<String, dynamic>> connect(@Context('user') AppUserDetails currentUser) async {
    final url = _service.startConnect(_redirectUri, currentUser.id);
    return {'url': url};
  }
}

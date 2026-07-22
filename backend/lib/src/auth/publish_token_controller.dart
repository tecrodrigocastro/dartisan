import 'package:vaden/vaden.dart';

import 'app_user_details.dart';
import 'publish_token_dto.dart';
import 'publish_token_service.dart';

// Protegido pelo catch-all AnyRequest().authenticated() do HttpSecurity
// (SecurityConfiguration) — exige sessão JWT válida, não PublishToken.
@Api(
  tag: 'PublishTokens',
  description: 'Gerencia os publish tokens do usuário autenticado',
)
@Controller('/api/publish-tokens')
class PublishTokenController {
  final PublishTokenService _service;

  PublishTokenController(this._service);

  @Post('/')
  Future<ResponseEntity<PublishTokenCreatedDTO>> create(
    @Context('user') AppUserDetails currentUser,
  ) async {
    final created = await _service.create(currentUser.id);
    return ResponseEntity(created, statusCode: 201);
  }

  @Get('/')
  Future<List<PublishTokenDTO>> list(
    @Context('user') AppUserDetails currentUser,
  ) {
    return _service.list(currentUser.id);
  }

  @Delete('/<id>')
  Future<Map<String, dynamic>> revoke(
    @Context('user') AppUserDetails currentUser,
    @Param('id') int id,
  ) async {
    final revoked = await _service.revoke(currentUser.id, id);
    if (!revoked) {
      throw ResponseException.notFound({
        'error': {
          'code': 'not_found',
          'message': 'Publish token não encontrado',
        },
      });
    }
    return {'success': true};
  }
}

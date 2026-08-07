import 'package:vaden/vaden.dart';

import '../auth/app_user_details.dart';
import '../auth/user_repository.dart';
import 'me_dto.dart';
import 'package_dto.dart';
import 'package_service.dart';

// Prefixo próprio (/api/me, não /api/packages) de propósito: o SecurityConfiguration
// libera GET /api/packages/**/* pra leitura pública (itens 1-2); um endpoint
// autenticado sob esse mesmo prefixo exigiria uma exceção na regra em vez de
// simplesmente herdar o AnyRequest().authenticated() catch-all.
@Api(
  tag: 'Me',
  description: 'Perfil e pacotes do usuário autenticado',
)
@Controller('/api/me')
class MeController {
  final PackageService _packageService;
  final UserRepository _userRepository;

  MeController(this._packageService, this._userRepository);

  @Get('/')
  Future<MeDTO> me(@Context('user') AppUserDetails currentUser) async {
    final user = await _userRepository.findById(currentUser.id);
    if (user == null) {
      throw ResponseException.notFound({
        'error': {'code': 'not_found', 'message': 'Usuário não encontrado'},
      });
    }
    return MeDTO(
      username: user.username,
      role: user.role,
      createdAt: user.createdAt,
    );
  }

  @Get('/packages')
  Future<List<PackageSummaryDTO>> myPackages(
    @Context('user') AppUserDetails currentUser,
  ) {
    return _packageService.getPackagesUploadedBy(currentUser.id);
  }
}

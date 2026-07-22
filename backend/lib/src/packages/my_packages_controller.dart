import 'package:vaden/vaden.dart';

import '../auth/app_user_details.dart';
import 'package_dto.dart';
import 'package_service.dart';

// Prefixo próprio (/api/me, não /api/packages) de propósito: o SecurityConfiguration
// libera GET /api/packages/**/* pra leitura pública (itens 1-2); um endpoint
// autenticado sob esse mesmo prefixo exigiria uma exceção na regra em vez de
// simplesmente herdar o AnyRequest().authenticated() catch-all.
@Api(
  tag: 'Packages',
  description: 'Pacotes publicados pelo usuário autenticado',
)
@Controller('/api/me')
class MyPackagesController {
  final PackageService _service;

  MyPackagesController(this._service);

  @Get('/packages')
  Future<List<MyPackageDTO>> myPackages(
    @Context('user') AppUserDetails currentUser,
  ) {
    return _service.getPackagesUploadedBy(currentUser.id);
  }
}

import 'package:vaden/vaden.dart';

import '../auth/app_user_details.dart';
import 'package_dto.dart';
import 'package_service.dart';

@Api(
  tag: 'Packages',
  description: 'Metadados e download de pacotes (Pub repository spec v2)',
)
@Controller('/api/packages')
class PackageController {
  final PackageService _service;

  PackageController(this._service);

  // Query params ficam String e o parse é manual (int.tryParse) porque o
  // `_parse<PType>` gerado pelo Vaden faz `value as PType` quando PType não é
  // exatamente `int`/`double`/`bool` — `int?` cai nesse else e o cast de
  // String pra int? sempre lança. Bug do gerador (vaden_application.dart),
  // não dá pra corrigir aqui — contornado no tipo do parâmetro.
  @Get('/')
  Future<PackageListDTO> listPackages(
    @Query('limit') String? limit,
    @Query('offset') String? offset,
  ) {
    return _service.listRecentPackages(
      limit: int.tryParse(limit ?? '') ?? 12,
      offset: int.tryParse(offset ?? '') ?? 0,
    );
  }

  // shelf_router usa sintaxe <param>, não :param (a doc do vaden_core mostra
  // :param, mas não é o que a versão resolvida de shelf_router entende).
  @Get('/<name>')
  Future<ResponseEntity<PackageMetadataDTO>> getPackageMetadata(
    @Param('name') String name,
  ) async {
    final metadata = await _service.getPackageMetadata(name);
    return ResponseEntity(
      metadata,
      headers: {'Content-Type': 'application/vnd.pub.v2+json'},
    );
  }

  @Get('/<name>/versions/<version>.tar.gz')
  Future<Response> downloadArchive(
    @Param('name') String name,
    @Param('version') String version,
  ) async {
    final archive = await _service.getPackageArchive(name, version);
    return Response.ok(
      archive.data,
      headers: {'Content-Type': 'application/octet-stream'},
    );
  }

  // POST (não GET) de propósito: o matcher `/api/packages/**` só libera GET
  // sem autenticação (ver SecurityConfiguration) — POST cai no
  // AnyRequest().authenticated() catch-all automaticamente, sem precisar de
  // exceção na regra.
  @Post('/<name>/likes')
  Future<Map<String, dynamic>> toggleLike(
    @Param('name') String name,
    @Context('user') AppUserDetails currentUser,
  ) async {
    final (liked, count) = await _service.toggleLike(name, currentUser.id);
    return {'liked': liked, 'count': count};
  }
}

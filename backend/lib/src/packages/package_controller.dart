import 'package:vaden/vaden.dart';

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
}

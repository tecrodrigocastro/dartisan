import 'package:vaden/vaden.dart';

import '../auth/app_user_details.dart';
import '../auth/github_connection_service.dart';
import 'github_import_dto.dart';
import 'github_import_service.dart';

// Sob /api/github (não /api/auth/github, que é público) — todos os endpoints
// aqui exigem sessão, e caem naturalmente no catch-all AnyRequest().authenticated()
// do SecurityConfiguration por estarem fora do prefixo /api/auth/**.
@Api(
  tag: 'Github',
  description: 'Import/publicação de pacotes a partir de repositórios do GitHub',
)
@Controller('/api/github')
class GithubImportController {
  final GithubImportService _service;
  final GithubConnectionService _connections;
  final ApplicationSettings _settings;

  GithubImportController(this._service, this._connections, this._settings);

  int get _maxTarballSizeBytes =>
      _settings['publish']['max_tarball_size_bytes'] as int;

  @Get('/connection')
  Future<Map<String, dynamic>> connection(
    @Context('user') AppUserDetails currentUser,
  ) async {
    final connected = await _connections.isConnected(currentUser.id);
    return {'connected': connected};
  }

  @Get('/repos')
  Future<List<GithubRepoDTO>> repos(@Context('user') AppUserDetails currentUser) async {
    final repos = await _service.listRepos(currentUser.id);
    return repos
        .map(
          (r) => GithubRepoDTO(owner: r.owner, name: r.name, fullName: r.fullName, private: r.private),
        )
        .toList();
  }

  @Get('/repos/<owner>/<repo>/refs')
  Future<GithubRefsDTO> refs(
    @Param('owner') String owner,
    @Param('repo') String repo,
    @Context('user') AppUserDetails currentUser,
  ) async {
    final result = await _service.listRefs(currentUser.id, owner, repo);
    return GithubRefsDTO(branches: result.branches, tags: result.tags);
  }

  @Post('/import')
  Future<Map<String, dynamic>> import(
    @Body() GithubImportRequestDTO body,
    @Context('user') AppUserDetails currentUser,
  ) async {
    final packageName = await _service.import(
      userId: currentUser.id,
      owner: body.owner,
      repo: body.repo,
      ref: body.ref,
      maxSizeBytes: _maxTarballSizeBytes,
    );
    return {
      'success': {'message': 'Pacote importado e publicado com sucesso'},
      'package_name': packageName,
    };
  }
}

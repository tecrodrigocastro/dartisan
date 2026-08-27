import 'package:vaden/vaden.dart';

import '../auth/github_connection_service.dart';
import '../auth/github_oauth_client.dart';
import '../auth/user_repository.dart';
import 'github_tarball_repackager.dart';
import 'publish_service.dart';
import 'publish_validator.dart';

const _publisherRoles = {'publisher', 'admin'};

@Service()
class GithubImportService {
  final GithubConnectionService _connections;
  final GithubOAuthClient _client;
  final UserRepository _users;
  final PublishValidator _validator;
  final PublishService _publishService;

  GithubImportService(
    this._connections,
    this._client,
    this._users,
    this._validator,
    this._publishService,
  );

  Future<List<GithubRepo>> listRepos(int userId) async {
    final token = await _connections.getValidAccessToken(userId);
    return _client.listRepos(token);
  }

  /// Branches e tags juntos, branches primeiro — o caller decide como
  /// agrupar/rotular na UI.
  Future<({List<String> branches, List<String> tags})> listRefs(
    int userId,
    String owner,
    String repo,
  ) async {
    final token = await _connections.getValidAccessToken(userId);
    final branches = await _client.listBranches(token, owner, repo);
    final tags = await _client.listTags(token, owner, repo);
    return (branches: branches, tags: tags);
  }

  /// Devolve o nome do pacote (extraído do `pubspec.yaml` do repo, pode
  /// diferir do nome do repositório) — o frontend usa pra navegar direto
  /// pra `/packages/<nome>` depois do import.
  Future<String> import({
    required int userId,
    required String owner,
    required String repo,
    required String ref,
    required int maxSizeBytes,
  }) async {
    final user = await _users.findById(userId);
    if (user == null || !_publisherRoles.contains(user.role)) {
      throw ResponseException(403, {
        'error': {
          'code': 'forbidden',
          'message': 'Usuário não tem role publisher/admin',
        },
      });
    }

    final token = await _connections.getValidAccessToken(userId);
    final githubTarball = await _client.downloadTarball(token, owner, repo, ref);
    final tarballBytes = repackageGithubTarball(githubTarball);

    final artifact = await _validator.validate(
      tarballBytes: tarballBytes,
      maxSizeBytes: maxSizeBytes,
    );

    await _publishService.persistArtifact(
      artifact: artifact,
      tarballBytes: tarballBytes,
      uploaderUserId: userId,
    );

    return artifact.packageName;
  }
}

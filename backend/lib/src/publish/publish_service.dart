import 'package:vaden/vaden.dart';

import '../auth/publish_token_repository.dart';
import '../auth/token_hasher.dart';
import '../auth/user_repository.dart';
import '../packages/package_repository.dart';
import '../packages/package_storage.dart';
import '../packages/version_ordering.dart';
import 'publish_validator.dart';
import 'upload_session.dart';

const _publisherRoles = {'publisher', 'admin'};

abstract class PublishService {
  /// Passo 3.1 — valida o publish token e abre uma sessão de upload.
  Future<UploadSession> startUpload(String? authorizationHeader);

  /// Passo 3.2 — anexa o tarball recebido à sessão.
  Future<void> attachTarball(
    String sessionId,
    List<int> tarballBytes, {
    required int maxSizeBytes,
  });

  /// Passo 3.3 — valida e persiste. Lança ResponseException(400) se algo
  /// não bater com as regras do protocolo.
  Future<void> finishUpload(String sessionId, {required int maxSizeBytes});

  /// Persiste um artefato já validado — extraído de [finishUpload] pra ser
  /// reusado pelo import via GitHub (GithubImportService), que valida um
  /// tarball reempacotado em vez de vir do handshake de 3 passos do CLI.
  Future<void> persistArtifact({
    required PublishArtifact artifact,
    required List<int> tarballBytes,
    int? uploaderTokenId,
    int? uploaderUserId,
  });
}

@Service()
class PublishServiceImpl implements PublishService {
  final PublishTokenRepository _publishTokens;
  final UserRepository _users;
  final PackageRepository _packages;
  final PackageStorage _storage;
  final PublishValidator _validator;
  final UploadSessionStore _sessions;

  PublishServiceImpl(
    this._publishTokens,
    this._users,
    this._packages,
    this._storage,
    this._validator,
    this._sessions,
  );

  static const _invalidToken = {
    'error': {'code': 'invalid_token', 'message': 'Publish token inválido'},
  };

  @override
  Future<UploadSession> startUpload(String? authorizationHeader) async {
    if (authorizationHeader == null ||
        !authorizationHeader.toLowerCase().startsWith('bearer ')) {
      throw ResponseException.unauthorized(_invalidToken);
    }
    final rawToken = authorizationHeader.substring(7);

    final tokenRow = await _publishTokens.findActiveByHash(
      TokenHasher.hash(rawToken),
    );
    if (tokenRow == null) {
      throw ResponseException.unauthorized(_invalidToken);
    }

    final user = await _users.findById(tokenRow.userId);
    if (user == null) {
      throw ResponseException.unauthorized(_invalidToken);
    }
    if (!_publisherRoles.contains(user.role)) {
      throw ResponseException(403, {
        'error': {
          'code': 'forbidden',
          'message': 'Usuário não tem role publisher/admin',
        },
      });
    }

    await _publishTokens.touchLastUsed(tokenRow.id);

    return _sessions.create(userId: user.id, publishTokenId: tokenRow.id);
  }

  @override
  Future<void> attachTarball(
    String sessionId,
    List<int> tarballBytes, {
    required int maxSizeBytes,
  }) async {
    final session = _requireSession(sessionId);

    if (tarballBytes.length > maxSizeBytes) {
      _sessions.remove(sessionId);
      throw ResponseException.badRequest({
        'error': {
          'code': 'tarball_too_large',
          'message': 'Tarball excede o tamanho máximo permitido ($maxSizeBytes bytes)',
        },
      });
    }

    session.tarballBytes = tarballBytes;
  }

  @override
  Future<void> finishUpload(
    String sessionId, {
    required int maxSizeBytes,
  }) async {
    final session = _requireSession(sessionId);
    final tarballBytes = session.tarballBytes;
    if (tarballBytes == null) {
      throw ResponseException.badRequest({
        'error': {
          'code': 'no_upload',
          'message': 'Nenhum tarball foi enviado para essa sessão',
        },
      });
    }

    final actor = await _users.findById(session.userId);
    if (actor == null) {
      _sessions.remove(sessionId);
      throw ResponseException.unauthorized(_invalidToken);
    }

    final PublishArtifact artifact;
    try {
      artifact = await _validator.validate(
        tarballBytes: tarballBytes,
        maxSizeBytes: maxSizeBytes,
        actorUserId: actor.id,
        actorRole: actor.role,
      );
    } finally {
      // A sessão é de uso único, com sucesso ou erro de validação.
      _sessions.remove(sessionId);
    }

    await persistArtifact(
      artifact: artifact,
      tarballBytes: tarballBytes,
      uploaderTokenId: session.publishTokenId,
    );
  }

  @override
  Future<void> persistArtifact({
    required PublishArtifact artifact,
    required List<int> tarballBytes,
    int? uploaderTokenId,
    int? uploaderUserId,
  }) async {
    final archivePath = '${artifact.packageName}/${artifact.version}.tar.gz';
    // O tarball só vai para o caminho final depois do insert no banco: grava
    // em um arquivo temporário, deixa a unique (package, version) decidir
    // quem ganha numa publicação concorrente e então move (rename atômico).
    final stagingPath =
        '${artifact.packageName}/${artifact.version}.${TokenHasher.generateRawToken()}.part';
    await _storage.write(stagingPath, Stream.value(tarballBytes));

    try {
      final existingVersions = await _packages.findVersions(
        artifact.packageName,
      );
      final allVersions = [
        ...existingVersions.map((v) => v.version),
        artifact.version,
      ];

      await _packages.saveNewVersion(
        packageName: artifact.packageName,
        version: artifact.version,
        pubspecYaml: artifact.pubspecYaml,
        archiveSha256: artifact.archiveSha256,
        archivePath: archivePath,
        latestVersion: pickLatestVersion(sortVersions(allVersions)),
        uploaderTokenId: uploaderTokenId,
        uploaderUserId: uploaderUserId,
      );
    } catch (_) {
      try {
        await _storage.delete(stagingPath);
      } catch (_) {}

      // Insert falhou: se a versão existe agora, outra publicação ganhou a
      // corrida (a unique estourou) — devolve o erro de domínio, não um 500.
      if (await _packages.findVersion(artifact.packageName, artifact.version) !=
          null) {
        throw ResponseException(409, {
          'error': {
            'code': 'version_exists',
            'message':
                'Versão ${artifact.version} de ${artifact.packageName} já foi '
                'publicada — pacotes são imutáveis por versão',
          },
        });
      }
      rethrow;
    }

    await _storage.move(stagingPath, archivePath);
  }

  UploadSession _requireSession(String sessionId) {
    final session = _sessions.get(sessionId);
    if (session == null) {
      throw ResponseException.badRequest({
        'error': {
          'code': 'invalid_session',
          'message': 'Sessão de upload inválida ou expirada',
        },
      });
    }
    return session;
  }
}

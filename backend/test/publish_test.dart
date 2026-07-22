import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:backend/config/drift/app_database.dart';
import 'package:backend/src/auth/publish_token_repository.dart';
import 'package:backend/src/auth/token_hasher.dart';
import 'package:backend/src/auth/user_repository.dart';
import 'package:backend/src/publish/publish_service.dart';
import 'package:backend/src/publish/publish_validator.dart';
import 'package:backend/src/publish/upload_session.dart';
import 'package:test/test.dart';
import 'package:vaden/vaden.dart';

import 'package_service_test.dart' show FakePackageRepository, FakePackageStorage;

List<int> buildTarball(Map<String, String> files) {
  final archive = Archive();
  files.forEach((name, content) {
    final bytes = utf8.encode(content);
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  });
  return GZipEncoder().encode(TarEncoder().encode(archive))!;
}

const _validPubspec = 'name: meu_pacote\nversion: 1.0.0\n';

class FakePublishTokenRepository implements PublishTokenRepository {
  int _nextId = 1;
  final List<PublishToken> rows = [];
  final List<int> touched = [];

  @override
  Future<PublishToken> insert({
    required int userId,
    required String tokenHash,
  }) async {
    final row = PublishToken(
      id: _nextId++,
      userId: userId,
      tokenHash: tokenHash,
      createdAt: DateTime.now(),
    );
    rows.add(row);
    return row;
  }

  @override
  Future<List<PublishToken>> findByUserId(int userId) async =>
      rows.where((r) => r.userId == userId).toList();

  @override
  Future<PublishToken?> findActiveByHash(String tokenHash) async {
    for (final row in rows) {
      if (row.tokenHash == tokenHash && row.revokedAt == null) return row;
    }
    return null;
  }

  @override
  Future<void> touchLastUsed(int id) async => touched.add(id);

  @override
  Future<bool> revoke(int id, {required int userId}) async => false;
}

class FakeUserRepository implements UserRepository {
  final List<User> users = [];

  @override
  Future<User?> findByUsername(String username) async {
    for (final u in users) {
      if (u.username == username) return u;
    }
    return null;
  }

  @override
  Future<User?> findById(int id) async {
    for (final u in users) {
      if (u.id == id) return u;
    }
    return null;
  }
}

void main() {
  group('PublishValidator', () {
    late FakePackageRepository packages;
    late PublishValidator validator;

    setUp(() {
      packages = FakePackageRepository();
      validator = PublishValidator(packages);
    });

    test('rejeita tarball maior que o limite', () async {
      final tarball = buildTarball({'pubspec.yaml': _validPubspec});

      await expectLater(
        () => validator.validate(tarballBytes: tarball, maxSizeBytes: 1),
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', 400)),
      );
    });

    test('rejeita tarball sem pubspec.yaml', () async {
      final tarball = buildTarball({'README.md': 'oi'});

      await expectLater(
        () => validator.validate(
          tarballBytes: tarball,
          maxSizeBytes: 1000000,
        ),
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', 400)),
      );
    });

    test('rejeita pubspec sem version', () async {
      final tarball = buildTarball({'pubspec.yaml': 'name: meu_pacote\n'});

      await expectLater(
        () => validator.validate(
          tarballBytes: tarball,
          maxSizeBytes: 1000000,
        ),
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', 400)),
      );
    });

    test('rejeita version que não é semver válido', () async {
      final tarball = buildTarball({
        'pubspec.yaml': 'name: meu_pacote\nversion: not-a-version\n',
      });

      await expectLater(
        () => validator.validate(
          tarballBytes: tarball,
          maxSizeBytes: 1000000,
        ),
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', 400)),
      );
    });

    test('rejeita versão já publicada', () async {
      packages.versions = [
        PackageVersion(
          id: 1,
          packageName: 'meu_pacote',
          version: '1.0.0',
          pubspecYaml: _validPubspec,
          archiveSha256: 'x',
          archivePath: 'meu_pacote/1.0.0.tar.gz',
          uploadedAt: DateTime.now(),
        ),
      ];
      final tarball = buildTarball({'pubspec.yaml': _validPubspec});

      await expectLater(
        () => validator.validate(
          tarballBytes: tarball,
          maxSizeBytes: 1000000,
        ),
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', 400)),
      );
    });

    test('aceita tarball válido e calcula o sha256', () async {
      final tarball = buildTarball({'pubspec.yaml': _validPubspec});

      final artifact = await validator.validate(
        tarballBytes: tarball,
        maxSizeBytes: 1000000,
      );

      expect(artifact.packageName, 'meu_pacote');
      expect(artifact.version, '1.0.0');
      expect(artifact.archiveSha256, hasLength(64)); // hex sha256
    });
  });

  group('PublishService', () {
    late FakePublishTokenRepository publishTokens;
    late FakeUserRepository users;
    late FakePackageRepository packages;
    late FakePackageStorage storage;
    late PublishServiceImpl service;

    const rawToken = 'super-secret-publish-token';

    setUp(() {
      publishTokens = FakePublishTokenRepository();
      users = FakeUserRepository();
      packages = FakePackageRepository();
      storage = FakePackageStorage();

      service = PublishServiceImpl(
        publishTokens,
        users,
        packages,
        storage,
        PublishValidator(packages),
        UploadSessionStore(),
      );

      users.users.add(
        User(
          id: 1,
          username: 'ana@example.com',
          passwordHash: 'irrelevante-aqui',
          role: 'publisher',
          createdAt: DateTime.now(),
        ),
      );
    });

    Future<PublishToken> seedToken({String role = 'publisher'}) async {
      users.users
        ..clear()
        ..add(
          User(
            id: 1,
            username: 'ana@example.com',
            passwordHash: 'x',
            role: role,
            createdAt: DateTime.now(),
          ),
        );
      return publishTokens.insert(
        userId: 1,
        tokenHash: TokenHasher.hash(rawToken),
      );
    }

    test('startUpload sem Authorization falha com 401', () async {
      await expectLater(
        () => service.startUpload(null),
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', 401)),
      );
    });

    test('startUpload com token inexistente falha com 401', () async {
      await expectLater(
        () => service.startUpload('Bearer token-que-nao-existe'),
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', 401)),
      );
    });

    test('startUpload com role reader falha com 403', () async {
      await seedToken(role: 'reader');

      await expectLater(
        () => service.startUpload('Bearer $rawToken'),
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', 403)),
      );
    });

    test('startUpload com role publisher abre sessão', () async {
      final tokenRow = await seedToken();

      final session = await service.startUpload('Bearer $rawToken');

      expect(session.userId, 1);
      expect(session.publishTokenId, tokenRow.id);
      expect(publishTokens.touched, contains(tokenRow.id));
    });

    test('attachTarball com sessão inválida falha com 400', () async {
      await expectLater(
        () => service.attachTarball('sessao-que-nao-existe', [
          1,
          2,
        ], maxSizeBytes: 1000),
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', 400)),
      );
    });

    test('finishUpload sem tarball anexado falha com 400', () async {
      await seedToken();
      final session = await service.startUpload('Bearer $rawToken');

      await expectLater(
        () => service.finishUpload(session.id, maxSizeBytes: 1000000),
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', 400)),
      );
    });

    test(
      'fluxo completo: publica pacote novo e persiste tudo corretamente',
      () async {
        await seedToken();
        final session = await service.startUpload('Bearer $rawToken');
        final tarball = buildTarball({'pubspec.yaml': _validPubspec});

        await service.attachTarball(
          session.id,
          tarball,
          maxSizeBytes: 1000000,
        );
        await service.finishUpload(session.id, maxSizeBytes: 1000000);

        expect(packages.package?.name, 'meu_pacote');
        expect(packages.package?.latestVersion, '1.0.0');
        expect(packages.versions, hasLength(1));
        final saved = packages.versions.single;
        expect(saved.version, '1.0.0');
        expect(saved.pubspecYaml, _validPubspec);
        expect(storage.files.containsKey('meu_pacote/1.0.0.tar.gz'), isTrue);
      },
    );

    test('latestVersion não regride ao publicar uma versão mais antiga', () async {
      packages.package = Package(
        name: 'meu_pacote',
        createdAt: DateTime.now(),
        latestVersion: '2.0.0',
      );
      packages.versions = [
        PackageVersion(
          id: 1,
          packageName: 'meu_pacote',
          version: '2.0.0',
          pubspecYaml: 'name: meu_pacote\nversion: 2.0.0\n',
          archiveSha256: 'x',
          archivePath: 'meu_pacote/2.0.0.tar.gz',
          uploadedAt: DateTime.now(),
        ),
      ];

      await seedToken();
      final session = await service.startUpload('Bearer $rawToken');
      final tarball = buildTarball({
        'pubspec.yaml': 'name: meu_pacote\nversion: 0.5.0\n',
      });

      await service.attachTarball(session.id, tarball, maxSizeBytes: 1000000);
      await service.finishUpload(session.id, maxSizeBytes: 1000000);

      expect(packages.package?.latestVersion, '2.0.0');
      expect(packages.versions.map((v) => v.version), containsAll(['2.0.0', '0.5.0']));
    });
  });
}

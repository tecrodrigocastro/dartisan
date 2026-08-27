import 'package:backend/config/drift/app_database.dart';
import 'package:backend/src/auth/github_connection_service.dart';
import 'package:backend/src/auth/github_oauth_client.dart';
import 'package:backend/src/publish/github_import_service.dart';
import 'package:backend/src/publish/publish_service.dart';
import 'package:backend/src/publish/publish_validator.dart';
import 'package:test/test.dart';
import 'package:vaden/vaden.dart';

import 'package_service_test.dart' show FakePackageRepository;
import 'publish_test.dart' show FakeUserRepository;

// Nenhum dos métodos abaixo é exercitado nos testes de role (a checagem de
// role acontece antes de qualquer chamada de rede/GitHub) — noSuchMethod
// cobre o resto da interface pública sem precisar implementar tudo.
class _FakeConnections implements GithubConnectionService {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} não deveria ser chamado');
}

class _FakeClient implements GithubOAuthClient {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} não deveria ser chamado');
}

class _FakePublishService implements PublishService {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} não deveria ser chamado');
}

void main() {
  group('GithubImportService.import — checagem de role', () {
    late FakeUserRepository users;
    late FakePackageRepository packages;

    setUp(() {
      users = FakeUserRepository();
      packages = FakePackageRepository();
    });

    test('usuário com role reader não pode importar', () async {
      users.users.add(
        User(
          id: 1,
          username: 'ana@example.com',
          passwordHash: 'x',
          role: 'reader',
          createdAt: DateTime.now(),
        ),
      );

      final service = GithubImportService(
        _FakeConnections(),
        _FakeClient(),
        users,
        PublishValidator(packages),
        _FakePublishService(),
      );

      await expectLater(
        () => service.import(
          userId: 1,
          owner: 'acme',
          repo: 'pacote',
          ref: 'v1.0.0',
          maxSizeBytes: 1000000,
        ),
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', 403)),
      );
    });

    test('usuário inexistente não pode importar', () async {
      final service = GithubImportService(
        _FakeConnections(),
        _FakeClient(),
        users,
        PublishValidator(packages),
        _FakePublishService(),
      );

      await expectLater(
        () => service.import(
          userId: 999,
          owner: 'acme',
          repo: 'pacote',
          ref: 'v1.0.0',
          maxSizeBytes: 1000000,
        ),
        throwsA(isA<ResponseException>().having((e) => e.code, 'code', 403)),
      );
    });
  });
}

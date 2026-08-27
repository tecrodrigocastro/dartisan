import 'package:backend/config/drift/app_database.dart';
import 'package:backend/src/auth/github_connection_repository.dart';
import 'package:backend/src/auth/github_connection_service.dart';
import 'package:backend/src/auth/github_oauth_client.dart';
import 'package:backend/src/auth/token_cipher.dart';
import 'package:test/test.dart';
import 'package:vaden/vaden.dart';

class FakeGithubConnectionRepository implements GithubConnectionRepository {
  GithubConnection? row;

  @override
  Future<void> upsert({
    required int userId,
    required String accessTokenEncrypted,
    String? refreshTokenEncrypted,
    DateTime? accessTokenExpiresAt,
  }) async {
    row = GithubConnection(
      userId: userId,
      accessTokenEncrypted: accessTokenEncrypted,
      refreshTokenEncrypted: refreshTokenEncrypted,
      accessTokenExpiresAt: accessTokenExpiresAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<GithubConnection?> findByUserId(int userId) async =>
      row?.userId == userId ? row : null;
}

// `implements` (não `extends`) sobre a classe concreta — Dart trata isso como
// implementar a interface pública dela; só refreshAccessToken é exercitado
// aqui, o resto lança se for chamado por engano.
class FakeGithubOAuthClient implements GithubOAuthClient {
  int refreshCalls = 0;
  late String lastRefreshTokenUsed;

  @override
  Future<GithubTokenSet> refreshAccessToken(String refreshToken) async {
    refreshCalls++;
    lastRefreshTokenUsed = refreshToken;
    return const GithubTokenSet(
      accessToken: 'novo-access-token',
      refreshToken: 'novo-refresh-token',
      expiresIn: Duration(hours: 8),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} não faz parte deste fake');
}

void main() {
  late FakeGithubConnectionRepository repository;
  late FakeGithubOAuthClient client;
  late TokenCipher cipher;
  late GithubConnectionService service;

  setUp(() {
    repository = FakeGithubConnectionRepository();
    client = FakeGithubOAuthClient();
    cipher = TokenCipher(ApplicationSettings.load('application.yaml'));
    service = GithubConnectionService(repository, client, cipher);
  });

  test('getValidAccessToken sem conexão lança 400', () async {
    await expectLater(
      () => service.getValidAccessToken(1),
      throwsA(isA<ResponseException>().having((e) => e.code, 'code', 400)),
    );
  });

  test('getValidAccessToken devolve o token decriptado quando ainda não expirou', () async {
    await service.save(
      1,
      const GithubTokenSet(
        accessToken: 'token-valido',
        refreshToken: 'refresh-token',
        expiresIn: Duration(hours: 8),
      ),
    );

    final token = await service.getValidAccessToken(1);

    expect(token, 'token-valido');
    expect(client.refreshCalls, 0);
  });

  test('getValidAccessToken renova via refresh token quando expirado', () async {
    await service.save(
      1,
      const GithubTokenSet(
        accessToken: 'token-expirado',
        refreshToken: 'refresh-token-antigo',
        expiresIn: Duration(seconds: -10), // já expirado
      ),
    );

    final token = await service.getValidAccessToken(1);

    expect(token, 'novo-access-token');
    expect(client.refreshCalls, 1);
    expect(client.lastRefreshTokenUsed, 'refresh-token-antigo');

    // A renovação foi persistida — uma segunda chamada não deve renovar de novo.
    final tokenAgain = await service.getValidAccessToken(1);
    expect(tokenAgain, 'novo-access-token');
    expect(client.refreshCalls, 1);
  });

  test('getValidAccessToken sem refresh token expirado lança 400', () async {
    await service.save(
      1,
      const GithubTokenSet(
        accessToken: 'token-expirado',
        refreshToken: null,
        expiresIn: Duration(seconds: -10),
      ),
    );

    await expectLater(
      () => service.getValidAccessToken(1),
      throwsA(isA<ResponseException>().having((e) => e.code, 'code', 400)),
    );
  });

  test('isConnected reflete se há conexão salva', () async {
    expect(await service.isConnected(1), isFalse);

    await service.save(
      1,
      const GithubTokenSet(accessToken: 'x', refreshToken: null, expiresIn: null),
    );

    expect(await service.isConnected(1), isTrue);
  });
}

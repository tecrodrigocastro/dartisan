import 'package:backend/config/drift/app_database.dart';
import 'package:backend/src/auth/app_user_details.dart';
import 'package:backend/src/auth/auth_service.dart';
import 'package:backend/src/auth/refresh_token_repository.dart';
import 'package:backend/src/auth/token_hasher.dart';
import 'package:test/test.dart';
import 'package:vaden/vaden.dart';
import 'package:vaden_security/vaden_security.dart';

class FakeUserDetailsService implements UserDetailsService {
  AppUserDetails? user;

  @override
  Future<UserDetails?> loadUserByUsername(String username) async {
    if (user?.username == username) return user;
    return null;
  }
}

class FakeRefreshTokenRepository implements RefreshTokenRepository {
  int _nextId = 1;
  final List<RefreshToken> rows = [];

  @override
  Future<void> insert({
    required int userId,
    required String tokenHash,
    required DateTime expiresAt,
  }) async {
    rows.add(
      RefreshToken(
        id: _nextId++,
        userId: userId,
        tokenHash: tokenHash,
        createdAt: DateTime.now(),
        expiresAt: expiresAt,
      ),
    );
  }

  @override
  Future<RefreshToken?> findActiveByHash(String tokenHash) async {
    for (final row in rows) {
      if (row.tokenHash != tokenHash) continue;
      if (row.revokedAt != null) return null;
      if (row.expiresAt.isBefore(DateTime.now())) return null;
      return row;
    }
    return null;
  }

  @override
  Future<void> revoke(int id) async {
    final index = rows.indexWhere((r) => r.id == id);
    if (index == -1) return;
    final row = rows[index];
    rows[index] = RefreshToken(
      id: row.id,
      userId: row.userId,
      tokenHash: row.tokenHash,
      createdAt: row.createdAt,
      expiresAt: row.expiresAt,
      revokedAt: DateTime.now(),
    );
  }
}

void main() {
  late FakeUserDetailsService userDetailsService;
  late FakeRefreshTokenRepository refreshTokens;
  late PasswordEncoder passwordEncoder;
  late JwtService jwtService;
  late AuthServiceImpl service;

  const rawPassword = 'correct horse battery staple';

  setUp(() {
    userDetailsService = FakeUserDetailsService();
    refreshTokens = FakeRefreshTokenRepository();
    passwordEncoder = BCryptPasswordEncoder(cost: 4); // cost baixo, é teste
    // audiences não pode ser [] — dart_jsonwebtoken's Audience assert exige
    // lista não-vazia (mesma razão do application.yaml).
    jwtService = JwtService(secret: 'test-secret', audiences: ['test']);
    service = AuthServiceImpl(
      userDetailsService,
      passwordEncoder,
      jwtService,
      refreshTokens,
    );

    userDetailsService.user = AppUserDetails(
      id: 42,
      username: 'ana@example.com',
      password: passwordEncoder.encode(rawPassword),
      roles: ['publisher'],
    );
  });

  test('login com senha correta emite tokens e persiste o refresh', () async {
    final tokens = await service.login('ana@example.com', rawPassword);

    expect(tokens.accessToken, isNotEmpty);
    expect(tokens.refreshToken, isNotEmpty);
    expect(refreshTokens.rows, hasLength(1));
    expect(refreshTokens.rows.single.userId, 42);
    expect(
      refreshTokens.rows.single.tokenHash,
      TokenHasher.hash(tokens.refreshToken),
    );
  });

  test('login com senha errada lança 401', () async {
    await expectLater(
      () => service.login('ana@example.com', 'senha-errada'),
      throwsA(isA<ResponseException>().having((e) => e.code, 'code', 401)),
    );
  });

  test('login com usuário inexistente lança 401', () async {
    await expectLater(
      () => service.login('fantasma@example.com', rawPassword),
      throwsA(isA<ResponseException>().having((e) => e.code, 'code', 401)),
    );
  });

  test('refresh rotaciona: revoga o antigo e emite um par novo', () async {
    final first = await service.login('ana@example.com', rawPassword);

    await service.refresh(first.refreshToken);

    // Não comparamos o token novo com o antigo por conteúdo: dois tokens
    // gerados no mesmo segundo (mesmo "iat") podem ser byte-a-byte iguais,
    // já que o JWT não carrega nonce. O que importa é o estado no repositório.
    expect(refreshTokens.rows, hasLength(2));
    expect(
      refreshTokens.rows.firstWhere(
        (r) => r.tokenHash == TokenHasher.hash(first.refreshToken),
      ).revokedAt,
      isNotNull,
    );
  });

  test('reusar o mesmo refresh token depois de rotacionado falha', () async {
    final first = await service.login('ana@example.com', rawPassword);
    await service.refresh(first.refreshToken);

    await expectLater(
      () => service.refresh(first.refreshToken),
      throwsA(isA<ResponseException>().having((e) => e.code, 'code', 401)),
    );
  });

  test('refresh com token não-refresh (access token) falha', () async {
    final tokens = await service.login('ana@example.com', rawPassword);

    await expectLater(
      () => service.refresh(tokens.accessToken),
      throwsA(isA<ResponseException>().having((e) => e.code, 'code', 401)),
    );
  });

  test('logout revoga o refresh token', () async {
    final tokens = await service.login('ana@example.com', rawPassword);

    await service.logout(tokens.refreshToken);

    await expectLater(
      () => service.refresh(tokens.refreshToken),
      throwsA(isA<ResponseException>().having((e) => e.code, 'code', 401)),
    );
  });

  test('logout de um token que não existe não lança erro (idempotente)', () async {
    await service.logout('token-que-nunca-existiu');
  });
}

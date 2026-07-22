import 'package:vaden/vaden.dart';
import 'package:vaden_security/vaden_security.dart';

import 'app_user_details.dart';
import 'refresh_token_repository.dart';
import 'token_hasher.dart';

abstract class AuthService {
  Future<Tokenization> login(String username, String password);
  Future<Tokenization> refresh(String refreshToken);
  Future<void> logout(String refreshToken);
}

@Service()
class AuthServiceImpl implements AuthService {
  // Interface crua (não parametrizada) — ver comentário em
  // UserDetailsServiceImpl sobre por que isso é obrigatório pro DI resolver.
  final UserDetailsService _userDetailsService;
  final PasswordEncoder _passwordEncoder;
  final JwtService _jwtService;
  final RefreshTokenRepository _refreshTokens;

  AuthServiceImpl(
    this._userDetailsService,
    this._passwordEncoder,
    this._jwtService,
    this._refreshTokens,
  );

  static const _invalidCredentials = {
    'error': {
      'code': 'invalid_credentials',
      'message': 'Usuário ou senha inválidos',
    },
  };

  @override
  Future<Tokenization> login(String username, String password) async {
    final user = await _userDetailsService.loadUserByUsername(username);
    if (user == null || !_passwordEncoder.matches(password, user.password)) {
      throw ResponseException.unauthorized(_invalidCredentials);
    }

    return _issueTokens(user as AppUserDetails);
  }

  @override
  Future<Tokenization> refresh(String refreshToken) async {
    final claims = _jwtService.verifyToken(refreshToken);
    if (claims == null || claims['refresh'] != true) {
      throw ResponseException.unauthorized({
        'error': {'code': 'invalid_token', 'message': 'Refresh token inválido'},
      });
    }

    final tokenHash = TokenHasher.hash(refreshToken);
    final storedToken = await _refreshTokens.findActiveByHash(tokenHash);
    if (storedToken == null) {
      throw ResponseException.unauthorized({
        'error': {
          'code': 'invalid_token',
          'message': 'Refresh token revogado ou expirado',
        },
      });
    }

    final username = claims['sub'] as String?;
    final user = username == null
        ? null
        : await _userDetailsService.loadUserByUsername(username);
    if (user == null) {
      throw ResponseException.unauthorized(_invalidCredentials);
    }

    // Rotaciona: revoga o antigo e emite um par novo — evita reuso indefinido
    // do mesmo refresh token.
    await _refreshTokens.revoke(storedToken.id);
    return _issueTokens(user as AppUserDetails);
  }

  @override
  Future<void> logout(String refreshToken) async {
    final tokenHash = TokenHasher.hash(refreshToken);
    final storedToken = await _refreshTokens.findActiveByHash(tokenHash);
    if (storedToken != null) {
      await _refreshTokens.revoke(storedToken.id);
    }
  }

  Future<Tokenization> _issueTokens(AppUserDetails user) async {
    final tokens = _jwtService.generateToken(user);

    await _refreshTokens.insert(
      userId: user.id,
      tokenHash: TokenHasher.hash(tokens.refreshToken),
      expiresAt: DateTime.now().add(_jwtService.refreshTokenValidity),
    );

    return tokens;
  }
}

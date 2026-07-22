import 'package:shared_preferences/shared_preferences.dart';

/// Persistência dos tokens de sessão. `shared_preferences` (localStorage na
/// web) em vez de `flutter_secure_storage` — este frontend só roda em web/
/// (ver docs/roadmap/06-frontend-web.md), e nesse alvo os dois têm a mesma
/// exposição (JS lê ambos na mesma origem).
class TokenStorage {
  static const _accessTokenKey = 'dartisan.access_token';
  static const _refreshTokenKey = 'dartisan.refresh_token';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<String?> readAccessToken() async =>
      (await _instance).getString(_accessTokenKey);

  Future<String?> readRefreshToken() async =>
      (await _instance).getString(_refreshTokenKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await _instance;
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> clear() async {
    final prefs = await _instance;
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}

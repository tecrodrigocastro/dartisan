import 'dart:convert';

/// Decodifica claims de um JWT sem verificar a assinatura — uso client-side
/// apenas para UI (role gating, expiração aproximada). O backend sempre
/// revalida a assinatura em cada request.
class JwtClaims {
  final String? subject;
  final List<String> roles;
  final DateTime? expiresAt;

  JwtClaims({required this.subject, required this.roles, required this.expiresAt});

  bool get isExpired =>
      expiresAt == null || expiresAt!.isBefore(DateTime.now());

  static JwtClaims decode(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return JwtClaims(subject: null, roles: const [], expiresAt: null);
    }

    final payload = jsonDecode(_decodeBase64Url(parts[1])) as Map<String, dynamic>;
    final exp = payload['exp'];
    final roles = payload['roles'];

    return JwtClaims(
      subject: payload['sub'] as String?,
      roles: roles is List ? roles.cast<String>() : const [],
      expiresAt: exp is int
          ? DateTime.fromMillisecondsSinceEpoch(exp * 1000)
          : null,
    );
  }

  static String _decodeBase64Url(String input) {
    final normalized = base64Url.normalize(input);
    return utf8.decode(base64Url.decode(normalized));
  }
}

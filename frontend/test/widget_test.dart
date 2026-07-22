import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/jwt/jwt_decoder.dart';
import 'package:frontend/packages/search/package_search_controller.dart';
import 'package:frontend/packages/search/package_search_state.dart';

String _base64UrlSegment(Map<String, dynamic> segment) =>
    base64Url.encode(utf8.encode(jsonEncode(segment))).replaceAll('=', '');

String _fakeJwt(Map<String, dynamic> payload) =>
    '${_base64UrlSegment({'alg': 'HS256'})}.${_base64UrlSegment(payload)}.signature';

void main() {
  group('PackageSearchController.validate', () {
    test('rejects empty input', () {
      final controller = PackageSearchController();
      expect(controller.validate('   '), isNull);
      expect(controller.value, isA<PackageSearchInvalid>());
    });

    test('rejects names with invalid characters', () {
      final controller = PackageSearchController();
      expect(controller.validate('my-package!'), isNull);
      expect(controller.value, isA<PackageSearchInvalid>());
    });

    test('accepts a valid package name and trims it', () {
      final controller = PackageSearchController();
      expect(controller.validate('  meu_pacote  '), 'meu_pacote');
      expect(controller.value, isA<PackageSearchIdle>());
    });
  });

  group('JwtClaims.decode', () {
    test('extracts sub, roles and expiration', () {
      final exp = DateTime.now().add(const Duration(minutes: 15));
      final token = _fakeJwt({
        'sub': 'rodrigo',
        'roles': ['publisher'],
        'exp': exp.millisecondsSinceEpoch ~/ 1000,
      });

      final claims = JwtClaims.decode(token);

      expect(claims.subject, 'rodrigo');
      expect(claims.roles, ['publisher']);
      expect(claims.isExpired, isFalse);
    });

    test('treats a past exp as expired', () {
      final token = _fakeJwt({
        'sub': 'rodrigo',
        'roles': <String>[],
        'exp': DateTime.now().subtract(const Duration(minutes: 1)).millisecondsSinceEpoch ~/ 1000,
      });

      expect(JwtClaims.decode(token).isExpired, isTrue);
    });
  });
}

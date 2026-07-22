import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

// Refresh tokens e publish tokens são segredos de alta entropia (não senhas
// escolhidas por humanos), então sha256 é apropriado aqui — bcrypt seria
// custo desnecessário sem ganho de segurança real nesse caso.
class TokenHasher {
  static String hash(String rawToken) {
    return sha256.convert(utf8.encode(rawToken)).toString();
  }

  static String generateRawToken({int bytes = 32}) {
    final random = Random.secure();
    final values = List<int>.generate(bytes, (_) => random.nextInt(256));
    return base64Url.encode(values).replaceAll('=', '');
  }
}

import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';
import 'package:vaden/vaden.dart';

/// Criptografia reversível (não hash) pro token do GitHub — precisa ser
/// reenviado pro GitHub em cada chamada, diferente de senha/publish token
/// (que são só hash porque nunca precisam ser lidos de volta). Chave
/// derivada de `security.secret` (SHA-256 → 32 bytes) — não introduz uma
/// config nova só pra isso.
@Component()
class TokenCipher {
  static final _algorithm = AesGcm.with256bits();

  final SecretKey _key;

  TokenCipher(ApplicationSettings settings)
    : _key = SecretKey(
        crypto.sha256
            .convert(utf8.encode(settings['security']['secret'] as String))
            .bytes,
      );

  Future<String> encryptToken(String plainText) async {
    final secretBox = await _algorithm.encrypt(utf8.encode(plainText), secretKey: _key);
    return base64Encode(secretBox.concatenation());
  }

  Future<String> decryptToken(String cipherText) async {
    final secretBox = SecretBox.fromConcatenation(
      base64Decode(cipherText),
      nonceLength: _algorithm.nonceLength,
      macLength: _algorithm.macAlgorithm.macLength,
    );
    final bytes = await _algorithm.decrypt(secretBox, secretKey: _key);
    return utf8.decode(bytes);
  }
}

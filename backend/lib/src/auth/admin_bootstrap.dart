import 'dart:io';

import 'package:vaden/vaden.dart';
import 'package:vaden_security/vaden_security.dart';

import 'user_repository.dart';

/// Garante o admin inicial a partir de `ADMIN_USERNAME` + `ADMIN_PASSWORD`.
///
/// Sem isso ninguém consegue virar admin (contas GitHub nascem `reader` e não
/// existe cadastro por senha). Regras:
/// - usuário não existe: cria com a senha informada e role `admin`;
/// - usuário existe com outra role: promove para `admin` (a senha NÃO é
///   trocada — a env var só define a senha na criação);
/// - variáveis ausentes: não faz nada.
///
/// É disparado de forma preguiçosa (primeiro `loadUserByUsername`) e
/// memoizado, então roda uma vez por processo antes do primeiro login.
@Component()
class AdminBootstrap {
  final UserRepository _users;
  final PasswordEncoder _passwordEncoder;
  final Map<String, String> _env;

  Future<void>? _done;

  AdminBootstrap(this._users, this._passwordEncoder)
    : _env = Platform.environment;

  /// Construtor para testes, com ambiente injetado.
  AdminBootstrap.withEnv(this._users, this._passwordEncoder, this._env);

  Future<void> ensure() => _done ??= _run().catchError((Object e) {
    // Falhou (ex.: banco ainda subindo): permite tentar de novo na próxima.
    _done = null;
    // ignore: avoid_print
    print('AdminBootstrap falhou: $e');
  });

  Future<void> _run() async {
    final username = _env['ADMIN_USERNAME']?.trim() ?? '';
    final password = _env['ADMIN_PASSWORD'] ?? '';
    if (username.isEmpty || password.isEmpty) return;

    final existing = await _users.findByUsername(username);
    if (existing == null) {
      await _users.createPasswordUser(
        username: username,
        passwordHash: _passwordEncoder.encode(password),
        role: 'admin',
      );
    } else if (existing.role != 'admin') {
      await _users.updateRole(existing.id, 'admin');
    }
  }
}

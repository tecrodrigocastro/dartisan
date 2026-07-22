import 'package:vaden/vaden.dart';
import 'package:vaden_security/vaden_security.dart';

import 'app_user_details.dart';
import 'user_repository.dart';

// Implementa a interface crua (não UserDetailsService<AppUserDetails>) de
// propósito: VadenSecurity.register() resolve com
// injector.tryGet<UserDetailsService>() (sem argumento genérico) — um
// registro parametrizado ficaria sob outra chave e o GlobalSecurityMiddleware
// nunca acharia esse bean (mesmo padrão do exemplo oficial do vaden).
@Service()
class UserDetailsServiceImpl implements UserDetailsService {
  final UserRepository _repository;

  UserDetailsServiceImpl(this._repository);

  @override
  Future<UserDetails?> loadUserByUsername(String username) async {
    final user = await _repository.findByUsername(username);
    if (user == null) return null;

    return AppUserDetails(
      id: user.id,
      username: user.username,
      password: user.passwordHash,
      roles: [user.role],
    );
  }
}

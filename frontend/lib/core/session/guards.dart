import 'package:flutter_modular/flutter_modular.dart';

import 'app_session.dart';
import 'session_state.dart';

/// Redireciona pra `/login` se não houver sessão autenticada. `SessionUnknown`
/// (restore ainda em andamento) é tratado como não-autenticado — default seguro.
String? authGuard(RouteState state) {
  final session = inject<AppSession>().value;
  return session is SessionAuthenticated ? null : '/login';
}

/// Combina com [authGuard] (deve vir antes, na lista de guards da rota):
/// se autenticado mas sem nenhuma das [roles], redireciona pra `/`.
ModularGuard requireAnyRole(List<String> roles) {
  return (state) {
    final session = inject<AppSession>().value;
    if (session is! SessionAuthenticated) return null; // authGuard já cobre isso
    final hasRole = roles.any(session.hasRole);
    return hasRole ? null : '/';
  };
}

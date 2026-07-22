/// Estado da sessão do usuário — State Pattern: cada variante carrega só o
/// que faz sentido para si (autenticado carrega username/roles, os outros
/// dois não carregam nada).
sealed class SessionState {
  const SessionState();
}

/// Ainda restaurando a sessão persistida (checagem inicial em andamento).
/// Guards tratam como não-autenticado — default seguro.
class SessionUnknown extends SessionState {
  const SessionUnknown();
}

class SessionAuthenticated extends SessionState {
  final String username;
  final List<String> roles;

  const SessionAuthenticated({required this.username, required this.roles});

  bool hasRole(String role) => roles.contains(role);
}

class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated();
}

import 'package:vaden/vaden.dart';
import 'package:vaden_security/vaden_security.dart';

import 'token_hasher.dart';

class _Expiring<T> {
  final T value;
  final DateTime createdAt;

  _Expiring(this.value) : createdAt = DateTime.now();

  bool isExpiredAt(DateTime now, Duration ttl) =>
      now.difference(createdAt) > ttl;
}

// Estado do login via GitHub (state CSRF + código de troca) vive em memória,
// não no Drift — é efêmero (segundos/minutos) e local a este processo, mesmo
// racional do UploadSessionStore (publish/upload_session.dart). Se isso rodar
// multi-instância no futuro, precisa virar algo compartilhado (Redis etc).
@Component()
class OAuthStateStore {
  static const _stateTtl = Duration(minutes: 10);
  static const _exchangeTtl = Duration(seconds: 60);

  final Map<String, _Expiring<int?>> _pendingStates = {};
  final Map<String, _Expiring<Tokenization>> _exchangeCodes = {};

  /// Gera e guarda um `state` novo pro passo de login/conectar (CSRF).
  /// [forUserId] marca isso como um fluxo de "conectar" (vincula o GitHub à
  /// conta já logada) em vez de login — `null` é login normal.
  String createState({int? forUserId}) {
    _purge(_pendingStates, _stateTtl);
    final state = TokenHasher.generateRawToken();
    _pendingStates[state] = _Expiring(forUserId);
    return state;
  }

  /// Consome (uso único) um `state` pendente. `valid=false` se não existia
  /// ou expirou; quando `valid=true`, `forUserId` diz se é conectar
  /// (não-nulo) ou login (nulo) — não dá pra usar só `bool` porque o próprio
  /// payload válido também pode ser `null`.
  ({bool valid, int? forUserId}) consumeState(String state) {
    _purge(_pendingStates, _stateTtl);
    final entry = _pendingStates.remove(state);
    if (entry == null) return (valid: false, forUserId: null);
    return (valid: true, forUserId: entry.value);
  }

  /// Guarda os tokens já emitidos sob um código de troca de uso único, pra
  /// não colocar o token cru na URL de redirect de volta pro frontend.
  String createExchangeCode(Tokenization tokens) {
    _purge(_exchangeCodes, _exchangeTtl);
    final code = TokenHasher.generateRawToken();
    _exchangeCodes[code] = _Expiring(tokens);
    return code;
  }

  /// Consome (uso único) um código de troca — `null` se inválido/expirado.
  Tokenization? consumeExchangeCode(String code) {
    _purge(_exchangeCodes, _exchangeTtl);
    return _exchangeCodes.remove(code)?.value;
  }

  void _purge<T>(Map<String, _Expiring<T>> map, Duration ttl) {
    final now = DateTime.now();
    map.removeWhere((_, entry) => entry.isExpiredAt(now, ttl));
  }
}

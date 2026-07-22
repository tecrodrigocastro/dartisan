import 'package:vaden/vaden.dart';

import '../auth/token_hasher.dart';

class UploadSession {
  final String id;
  final int userId;
  final int publishTokenId;
  final DateTime createdAt;

  /// Preenchido só depois do passo 3.2 (upload do tarball).
  List<int>? tarballBytes;

  UploadSession({
    required this.id,
    required this.userId,
    required this.publishTokenId,
    required this.createdAt,
  });

  bool isExpiredAt(DateTime now, Duration ttl) =>
      now.difference(createdAt) > ttl;
}

// Estado do handshake de 3 passos do publish vive em memória, não no Drift —
// é uma sessão curta (minutos) e local a este processo; se isso rodar
// multi-instância no futuro, precisa virar algo compartilhado (Redis etc).
@Component()
class UploadSessionStore {
  static const _ttl = Duration(minutes: 15);

  final Map<String, UploadSession> _sessions = {};

  UploadSession create({required int userId, required int publishTokenId}) {
    _purgeExpired();

    final session = UploadSession(
      id: TokenHasher.generateRawToken(),
      userId: userId,
      publishTokenId: publishTokenId,
      createdAt: DateTime.now(),
    );
    _sessions[session.id] = session;
    return session;
  }

  UploadSession? get(String id) {
    _purgeExpired();
    return _sessions[id];
  }

  void remove(String id) => _sessions.remove(id);

  void _purgeExpired() {
    final now = DateTime.now();
    _sessions.removeWhere((_, session) => session.isExpiredAt(now, _ttl));
  }
}

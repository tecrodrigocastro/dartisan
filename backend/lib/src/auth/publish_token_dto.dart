import 'package:vaden/vaden.dart';

@DTO()
class PublishTokenDTO {
  final int id;

  @JsonKey('created_at')
  final DateTime createdAt;

  @JsonKey('last_used_at')
  final DateTime? lastUsedAt;

  @JsonKey('revoked_at')
  final DateTime? revokedAt;

  PublishTokenDTO({
    required this.id,
    required this.createdAt,
    required this.lastUsedAt,
    required this.revokedAt,
  });
}

// Só existe uma vez, na resposta da criação — o token bruto nunca é
// recuperável depois (só o hash fica salvo).
@DTO()
class PublishTokenCreatedDTO {
  final int id;
  final String token;

  @JsonKey('created_at')
  final DateTime createdAt;

  PublishTokenCreatedDTO({
    required this.id,
    required this.token,
    required this.createdAt,
  });
}

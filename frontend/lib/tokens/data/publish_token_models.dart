class PublishToken {
  final int id;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final DateTime? revokedAt;

  const PublishToken({
    required this.id,
    required this.createdAt,
    required this.lastUsedAt,
    required this.revokedAt,
  });

  bool get isRevoked => revokedAt != null;

  factory PublishToken.fromJson(Map<String, dynamic> json) => PublishToken(
    id: json['id'] as int,
    createdAt: DateTime.parse(json['created_at'] as String),
    lastUsedAt: json['last_used_at'] != null
        ? DateTime.parse(json['last_used_at'] as String)
        : null,
    revokedAt: json['revoked_at'] != null
        ? DateTime.parse(json['revoked_at'] as String)
        : null,
  );
}

/// Só existe na resposta de criação — o token bruto nunca é recuperável depois.
class PublishTokenCreated {
  final int id;
  final String token;
  final DateTime createdAt;

  const PublishTokenCreated({
    required this.id,
    required this.token,
    required this.createdAt,
  });

  factory PublishTokenCreated.fromJson(Map<String, dynamic> json) =>
      PublishTokenCreated(
        id: json['id'] as int,
        token: json['token'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}

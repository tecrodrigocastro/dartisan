class Me {
  final String username;
  final String role;
  final DateTime createdAt;

  const Me({required this.username, required this.role, required this.createdAt});

  factory Me.fromJson(Map<String, dynamic> json) => Me(
    username: json['username'] as String,
    role: json['role'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}

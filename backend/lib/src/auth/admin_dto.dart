import 'package:vaden/vaden.dart';

@DTO()
class AdminUserDTO {
  final int id;
  final String username;
  final String role;

  @JsonKey('created_at')
  final DateTime createdAt;

  AdminUserDTO({
    required this.id,
    required this.username,
    required this.role,
    required this.createdAt,
  });
}

@DTO()
class UpdateRoleRequestDTO {
  final String role;

  UpdateRoleRequestDTO({required this.role});
}

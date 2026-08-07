import 'package:vaden/vaden.dart';

@DTO()
class MeDTO {
  final String username;
  final String role;

  @JsonKey('created_at')
  final DateTime createdAt;

  MeDTO({required this.username, required this.role, required this.createdAt});
}

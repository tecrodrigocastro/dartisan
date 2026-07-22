import 'package:vaden/vaden.dart';

@DTO()
class LoginRequestDTO {
  final String username;
  final String password;

  LoginRequestDTO({required this.username, required this.password});
}

@DTO()
class RefreshRequestDTO {
  @JsonKey('refresh_token')
  final String refreshToken;

  RefreshRequestDTO({required this.refreshToken});
}

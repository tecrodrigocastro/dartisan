import 'package:vaden/vaden.dart';
import 'package:vaden_security/vaden_security.dart';

@DTO()
class AppUserDetails extends UserDetails {
  final int id;

  AppUserDetails({
    required this.id,
    required super.username,
    required super.password,
    required super.roles,
  });
}

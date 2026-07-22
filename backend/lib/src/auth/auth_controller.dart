import 'package:vaden/vaden.dart';
import 'package:vaden_security/vaden_security.dart';

import 'auth_dto.dart';
import 'auth_service.dart';

// Nome próprio (não "AuthController") porque vaden_security já expõe uma
// classe AuthController — colidiria no scanner do vaden_class_scanner.
@Api(
  tag: 'Auth',
  description: 'Login/refresh/logout de sessão (JWT) para o frontend',
)
@Controller('/api/auth')
class AppAuthController {
  final AuthService _service;

  AppAuthController(this._service);

  @Post('/login')
  Future<Tokenization> login(@Body() LoginRequestDTO body) {
    return _service.login(body.username, body.password);
  }

  @Post('/refresh')
  Future<Tokenization> refresh(@Body() RefreshRequestDTO body) {
    return _service.refresh(body.refreshToken);
  }

  @Post('/logout')
  Future<Map<String, dynamic>> logout(@Body() RefreshRequestDTO body) async {
    await _service.logout(body.refreshToken);
    return {'success': true};
  }
}

import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../../core/session/app_session.dart';
import '../data/auth_api.dart';
import 'login_state.dart';

class LoginController extends ValueNotifier<LoginState> {
  final AuthApi _authApi;
  final AppSession _session;

  LoginController(this._authApi, this._session) : super(const LoginIdle());

  /// Retorna `true` em caso de sucesso — a página decide a navegação.
  Future<bool> submit(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      value = const LoginFailure('Preencha usuário e senha');
      return false;
    }

    value = const LoginSubmitting();
    try {
      final tokens = await _authApi.login(username, password);
      await _session.onLoginSuccess(tokens);
      value = const LoginIdle();
      return true;
    } on ApiException catch (e) {
      value = LoginFailure(e.message);
      return false;
    } catch (e) {
      value = LoginFailure(e.toString());
      return false;
    }
  }
}

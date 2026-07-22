sealed class LoginState {
  const LoginState();
}

class LoginIdle extends LoginState {
  const LoginIdle();
}

class LoginSubmitting extends LoginState {
  const LoginSubmitting();
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);
}

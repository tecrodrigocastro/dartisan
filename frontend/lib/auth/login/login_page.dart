import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/http/api_base_url.dart';
import '../../core/theme/tokens.dart';
import '../../shared/widgets/dotted_grid_background.dart';
import 'login_controller.dart';
import 'login_state.dart';

class LoginPage extends StatefulWidget {
  /// `true` quando a página foi aberta após um redirect de erro do fluxo
  /// OAuth do GitHub (`/login?error=github_oauth_failed`).
  final bool githubError;

  const LoginPage({super.key, this.githubError = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<LoginController>();
  }

  void _loginWithGithub() {
    launchUrl(
      Uri.parse('$apiBaseUrl/api/auth/github/login'),
      webOnlyWindowName: '_self',
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await _controller.submit(
      _usernameController.text,
      _passwordController.text,
    );
    if (ok && mounted) {
      context.navigate('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DottedGridBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.png', height: 48, fit: BoxFit.contain),
                  const SizedBox(height: 12),
                  Text('Dartisan', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    'Instância self-hosted',
                    style: TextStyle(color: context.colors.textFaint, fontSize: 13),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: ValueListenableBuilder<LoginState>(
                        valueListenable: _controller,
                        builder: (context, state, _) {
                          final submitting = state is LoginSubmitting;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bem-vindo de volta', style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 4),
                              Text(
                                'Acesse sua conta pra gerenciar pacotes.',
                                style: TextStyle(color: context.colors.textFaint, fontSize: 13),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Usuário',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                enabled: !submitting,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Senha',
                                  prefixIcon: Icon(Icons.lock_outline),
                                ),
                                obscureText: true,
                                enabled: !submitting,
                                onSubmitted: (_) => _submit(),
                              ),
                              if (state is LoginFailure) ...[
                                const SizedBox(height: 12),
                                Text(state.message, style: TextStyle(color: context.colors.danger)),
                              ] else if (widget.githubError) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'Não foi possível entrar com o GitHub. Tente de novo.',
                                  style: TextStyle(color: context.colors.danger),
                                ),
                              ],
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: submitting ? null : _submit,
                                  child: submitting
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Text('ENTRAR'),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(child: Divider(color: context.colors.borderStrong)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: DartisanSpacing.s3),
                                    child: Text(
                                      'OU CONTINUE COM',
                                      style: TextStyle(
                                        color: context.colors.textFaint,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: context.colors.borderStrong)),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: submitting ? null : _loginWithGithub,
                                  child: const Text('Continuar com GitHub'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

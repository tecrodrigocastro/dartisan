import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/http/api_base_url.dart';
import '../../core/theme/tokens.dart';
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
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      body: Row(
        children: [
          if (wide) const Expanded(child: _BrandPanel()),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(DartisanSpacing.s6),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: _buildForm(context, showLogo: !wide),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, {required bool showLogo}) {
    final colors = context.colors;
    return ValueListenableBuilder<LoginState>(
      valueListenable: _controller,
      builder: (context, state, _) {
        final submitting = state is LoginSubmitting;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showLogo) ...[
              Row(
                children: [
                  Image.asset('assets/logo.png', height: 32, fit: BoxFit.contain),
                  const SizedBox(width: DartisanSpacing.s2),
                  Text('Dartisan', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: DartisanSpacing.s6),
            ],
            Text('Entrar', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: DartisanSpacing.s2),
            Text(
              'Acesse sua conta para gerenciar pacotes e tokens.',
              style: TextStyle(color: colors.textFaint),
            ),
            const SizedBox(height: DartisanSpacing.s6),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: submitting ? null : _loginWithGithub,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                icon: const Icon(Icons.code, size: 20),
                label: const Text('Continuar com GitHub'),
              ),
            ),
            if (widget.githubError) ...[
              const SizedBox(height: DartisanSpacing.s3),
              Text(
                'Não foi possível entrar com o GitHub. Tente de novo.',
                style: TextStyle(color: colors.danger),
              ),
            ],
            const SizedBox(height: DartisanSpacing.s5),
            Row(
              children: [
                Expanded(child: Divider(color: colors.borderStrong)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: DartisanSpacing.s3),
                  child: Text(
                    'OU COM USUÁRIO',
                    style: TextStyle(
                      color: colors.textFaint,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: colors.borderStrong)),
              ],
            ),
            const SizedBox(height: DartisanSpacing.s5),
            TextField(
              controller: _usernameController,
              style: DartisanFonts.mono(fontSize: 15),
              decoration: const InputDecoration(labelText: 'Usuário'),
              enabled: !submitting,
              autofillHints: const [AutofillHints.username],
            ),
            const SizedBox(height: DartisanSpacing.s4),
            TextField(
              controller: _passwordController,
              style: DartisanFonts.mono(fontSize: 15),
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
              enabled: !submitting,
              autofillHints: const [AutofillHints.password],
              onSubmitted: (_) => _submit(),
            ),
            if (state is LoginFailure) ...[
              const SizedBox(height: DartisanSpacing.s3),
              Text(state.message, style: TextStyle(color: colors.danger)),
            ],
            const SizedBox(height: DartisanSpacing.s5),
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
                    : const Text('Entrar'),
              ),
            ),
            const SizedBox(height: DartisanSpacing.s5),
            Text(
              'Contas novas entram como leitor. Um administrador libera a permissão de publicar.',
              style: TextStyle(color: colors.textFaint, fontSize: 13),
            ),
          ],
        );
      },
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(DartisanSpacing.s7),
      decoration: BoxDecoration(
        color: colors.codeBackground,
        border: Border(right: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => context.navigate('/'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo.png', height: 32, fit: BoxFit.contain),
                const SizedBox(width: DartisanSpacing.s3),
                Text('Dartisan', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'INSTÂNCIA SELF-HOSTED',
                style: DartisanFonts.mono(fontSize: 12, fontWeight: FontWeight.w500, color: colors.brass),
              ),
              const SizedBox(height: DartisanSpacing.s4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Text(
                  'Publique e gerencie seus pacotes em casa.',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(height: 1.1),
                ),
              ),
              const SizedBox(height: DartisanSpacing.s6),
              Container(
                padding: const EdgeInsets.all(DartisanSpacing.s4),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(DartisanRadii.m),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: SelectableText.rich(
                  TextSpan(
                    style: DartisanFonts.mono(fontSize: 13, height: 1.8),
                    children: [
                      TextSpan(text: '\$ ', style: TextStyle(color: primary)),
                      TextSpan(text: 'dart pub token add $apiBaseUrl\n'),
                      TextSpan(text: '\$ ', style: TextStyle(color: primary)),
                      const TextSpan(text: 'dart pub publish'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Open source · licença MIT',
            style: TextStyle(color: colors.textFaint, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/session/app_session.dart';
import '../data/auth_api.dart';

/// Página de destino do redirect final do fluxo OAuth do GitHub — troca o
/// código de uso único (na URL) pelos tokens de verdade e loga o usuário.
/// Ver GithubOAuthController no backend pro resto do fluxo.
class GithubCallbackPage extends StatefulWidget {
  final String? code;
  const GithubCallbackPage({super.key, required this.code});

  @override
  State<GithubCallbackPage> createState() => _GithubCallbackPageState();
}

class _GithubCallbackPageState extends State<GithubCallbackPage> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _exchange();
  }

  Future<void> _exchange() async {
    final code = widget.code;
    if (code == null) {
      setState(() => _error = 'Código de login ausente.');
      return;
    }

    try {
      final tokens = await inject<AuthApi>().exchangeGithubCode(code);
      await inject<AppSession>().onLoginSuccess(tokens);
      if (mounted) context.navigate('/');
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Não foi possível concluir o login com GitHub.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _error == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => context.navigate('/login'),
                    child: const Text('Voltar pro login'),
                  ),
                ],
              ),
      ),
    );
  }
}

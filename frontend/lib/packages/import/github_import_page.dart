import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/tokens.dart';
import '../../shared/widgets/app_top_bar.dart';
import 'data/github_import_api.dart';
import 'data/github_import_models.dart';
import 'github_import_controller.dart';
import 'github_import_state.dart';

class GithubImportPage extends StatefulWidget {
  const GithubImportPage({super.key});

  @override
  State<GithubImportPage> createState() => _GithubImportPageState();
}

class _GithubImportPageState extends State<GithubImportPage> {
  late final GithubImportController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<GithubImportController>();
    _controller.load();
  }

  Future<void> _connect() async {
    // inject<T>() (não context.read<T>()) porque GithubImportApi é um
    // singleton root-owned (registrado em coreModule), fora do escopo local
    // desta rota — mesmo padrão de AppTopBar/GithubCallbackPage.
    //
    // Busca a URL via XHR autenticado (Dio anexa o Bearer token) e só então
    // navega o browser pra ela — window.location não consegue mandar header
    // nenhum, ver comentário em GithubConnectController no backend.
    final url = await inject<GithubImportApi>().getConnectUrl();
    if (!mounted) return;
    launchUrl(Uri.parse(url), webOnlyWindowName: '_self');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: ValueListenableBuilder<GithubImportState>(
        valueListenable: _controller,
        builder: (context, state, _) {
          if (state is GithubImportSuccess) {
            // Navegação dentro do build: agenda pro próximo frame pra não
            // chamar Navigator/Modular durante a fase de build em si.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) context.navigate('/packages/${state.packageName}');
            });
            return const Center(child: CircularProgressIndicator());
          }

          return switch (state) {
            GithubImportLoading() => const Center(child: CircularProgressIndicator()),
            GithubImportNotConnected() => _NotConnectedView(onConnect: _connect),
            GithubImportLoadFailure(:final message) => _ErrorView(
              message: message,
              onRetry: _controller.load,
            ),
            GithubImportReady() => _ReadyView(state: state, controller: _controller),
            GithubImportSuccess() => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _NotConnectedView extends StatelessWidget {
  final VoidCallback onConnect;
  const _NotConnectedView({required this.onConnect});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.link_off, size: 48, color: context.colors.textFaint),
          const SizedBox(height: DartisanSpacing.s4),
          Text(
            'Conecte sua conta do GitHub',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: DartisanSpacing.s2),
          Text(
            'Pra importar um repositório privado, o Dartisan precisa\n'
            'de permissão de leitura na sua conta do GitHub.',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.textFaint),
          ),
          const SizedBox(height: DartisanSpacing.s5),
          FilledButton(onPressed: onConnect, child: const Text('Conectar GitHub')),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: context.colors.danger),
          const SizedBox(height: DartisanSpacing.s4),
          Text(message),
          const SizedBox(height: DartisanSpacing.s4),
          FilledButton(onPressed: onRetry, child: const Text('Tentar de novo')),
        ],
      ),
    );
  }
}

class _ReadyView extends StatelessWidget {
  final GithubImportReady state;
  final GithubImportController controller;
  const _ReadyView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final canSubmit =
        state.selectedRepo != null && state.selectedRef != null && !state.submitting;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(DartisanSpacing.s5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Importar do GitHub', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: DartisanSpacing.s2),
              Text(
                'Escolha um repositório e uma versão (branch ou tag) pra publicar.',
                style: TextStyle(color: colors.textFaint),
              ),
              const SizedBox(height: DartisanSpacing.s6),
              Text('Repositório', style: TextStyle(fontSize: 12, color: colors.textFaint)),
              const SizedBox(height: DartisanSpacing.s2),
              DropdownButtonFormField<GithubRepo>(
                initialValue: state.selectedRepo,
                isExpanded: true,
                hint: const Text('Selecione um repositório'),
                items: state.repos
                    .map(
                      (repo) => DropdownMenuItem(
                        value: repo,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              repo.private ? Icons.lock_outline : Icons.public,
                              size: 14,
                              color: colors.textFaint,
                            ),
                            const SizedBox(width: 6),
                            Flexible(child: Text(repo.fullName, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (repo) {
                  if (repo != null) controller.selectRepo(repo);
                },
              ),
              const SizedBox(height: DartisanSpacing.s4),
              Text('Versão', style: TextStyle(fontSize: 12, color: colors.textFaint)),
              const SizedBox(height: DartisanSpacing.s2),
              if (state.loadingRefs)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: DartisanSpacing.s3),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                )
              else
                DropdownButtonFormField<String>(
                  initialValue: state.selectedRef,
                  isExpanded: true,
                  hint: const Text('Selecione uma branch ou tag'),
                  items: [
                    ...?state.refs?.branches.map(
                      (b) => DropdownMenuItem(value: b, child: Text('🌿 $b')),
                    ),
                    ...?state.refs?.tags.map(
                      (t) => DropdownMenuItem(value: t, child: Text('🏷 $t')),
                    ),
                  ],
                  onChanged: state.selectedRepo == null
                      ? null
                      : (ref) {
                          if (ref != null) controller.selectRef(ref);
                        },
                ),
              if (state.error != null) ...[
                const SizedBox(height: DartisanSpacing.s3),
                Text(state.error!, style: TextStyle(color: colors.danger)),
              ],
              const SizedBox(height: DartisanSpacing.s6),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: canSubmit ? controller.submit : null,
                  child: state.submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Importar e publicar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

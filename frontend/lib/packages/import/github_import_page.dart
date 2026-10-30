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
            style: Theme.of(context).textTheme.headlineSmall,
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

class _ReadyView extends StatefulWidget {
  final GithubImportReady state;
  final GithubImportController controller;
  const _ReadyView({required this.state, required this.controller});

  @override
  State<_ReadyView> createState() => _ReadyViewState();
}

class _ReadyViewState extends State<_ReadyView> {
  bool _showTags = false;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final controller = widget.controller;
    final colors = context.colors;
    final canSubmit =
        state.selectedRepo != null && state.selectedRef != null && !state.submitting;
    final refNames = _showTags ? (state.refs?.tags ?? const <String>[]) : (state.refs?.branches ?? const <String>[]);

    final repoColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('Repositório'),
        for (final repo in state.repos)
          _OptionTile(
            icon: repo.private ? Icons.lock_outline : Icons.public,
            label: repo.fullName,
            trailing: repo.private ? 'privado' : 'público',
            selected: state.selectedRepo == repo,
            onTap: () => controller.selectRepo(repo),
          ),
      ],
    );

    final refColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('Versão'),
        SegmentedButton<bool>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: false, label: Text('Branches')),
            ButtonSegment(value: true, label: Text('Tags')),
          ],
          selected: {_showTags},
          onSelectionChanged: (v) => setState(() => _showTags = v.first),
        ),
        const SizedBox(height: DartisanSpacing.s3),
        if (state.selectedRepo == null)
          Text('Escolha um repositório primeiro.', style: TextStyle(color: colors.textFaint))
        else if (state.loadingRefs)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: DartisanSpacing.s3),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          )
        else if (refNames.isEmpty)
          Text(
            _showTags ? 'Nenhuma tag neste repositório.' : 'Nenhuma branch encontrada.',
            style: TextStyle(color: colors.textFaint),
          )
        else
          for (final name in refNames)
            _OptionTile(
              icon: _showTags ? Icons.sell_outlined : Icons.call_split,
              label: name,
              selected: state.selectedRef == name,
              onTap: () => controller.selectRef(name),
            ),
      ],
    );

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Padding(
            padding: const EdgeInsets.all(DartisanSpacing.s5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Importar do GitHub', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: DartisanSpacing.s2),
                Text(
                  'Escolha um repositório e uma versão (branch ou tag). O Dartisan valida o pubspec e publica o pacote por você.',
                  style: TextStyle(color: colors.textFaint, fontSize: 16),
                ),
                const SizedBox(height: DartisanSpacing.s5),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(DartisanSpacing.s5),
                        child: LayoutBuilder(
                          builder: (context, box) {
                            if (box.maxWidth < 640) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  repoColumn,
                                  const SizedBox(height: DartisanSpacing.s5),
                                  refColumn,
                                ],
                              );
                            }
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: repoColumn),
                                const SizedBox(width: DartisanSpacing.s5),
                                Expanded(child: refColumn),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DartisanSpacing.s5,
                          vertical: DartisanSpacing.s4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.codeBackground,
                          border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: DartisanSpacing.s3,
                          spacing: DartisanSpacing.s4,
                          children: [
                            Text.rich(
                              TextSpan(
                                style: DartisanFonts.mono(fontSize: 13, color: colors.textFaint),
                                children: [
                                  TextSpan(
                                    text: state.selectedRepo?.fullName ?? 'nenhum repositório',
                                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                  if (state.selectedRef != null) ...[
                                    TextSpan(text: ' @ ', style: TextStyle(color: colors.brass)),
                                    TextSpan(
                                      text: state.selectedRef,
                                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            FilledButton(
                              onPressed: canSubmit ? controller.submit : null,
                              child: state.submitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Importar e publicar'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.error != null) ...[
                  const SizedBox(height: DartisanSpacing.s3),
                  Text(state.error!, style: TextStyle(color: colors.danger)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DartisanSpacing.s3),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.7,
          color: context.colors.textFaint,
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: DartisanSpacing.s2),
      child: Material(
        color: selected ? colors.accentSoft : Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DartisanRadii.m - 2),
          side: BorderSide(color: selected ? primary : Theme.of(context).dividerColor),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(DartisanRadii.m - 2),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(icon, size: 16, color: colors.textFaint),
                const SizedBox(width: DartisanSpacing.s3),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: DartisanFonts.mono(fontSize: 13.5),
                  ),
                ),
                if (trailing != null)
                  Text(
                    trailing!,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.textFaint),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

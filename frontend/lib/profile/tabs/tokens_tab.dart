import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/formatting/date_format.dart';
import '../../core/theme/tokens.dart';
import '../../shared/widgets/status_pill.dart';
import '../../tokens/data/publish_token_models.dart';
import '../../tokens/tokens_controller.dart';
import '../../tokens/tokens_state.dart';

class TokensTab extends StatefulWidget {
  const TokensTab({super.key});

  @override
  State<TokensTab> createState() => _TokensTabState();
}

class _TokensTabState extends State<TokensTab> {
  late final TokensController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<TokensController>();
    _controller.load();
  }

  Future<void> _createToken() async {
    final created = await _controller.create();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CreatedTokenDialog(created: created),
    );
  }

  Future<void> _revoke(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revogar token?'),
        content: const Text('Aplicações usando esse token vão parar de conseguir publicar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Revogar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _controller.revoke(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TokensState>(
      valueListenable: _controller,
      builder: (context, state, _) {
        return switch (state) {
          TokensLoading() => const Center(child: CircularProgressIndicator()),
          TokensFailure(:final message) => Center(child: Text(message)),
          TokensLoaded(:final tokens) => ListView(
            padding: const EdgeInsets.all(DartisanSpacing.s5),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tokens de publicação', style: Theme.of(context).textTheme.headlineSmall),
                  FilledButton.icon(
                    onPressed: _createToken,
                    icon: const Icon(Icons.add),
                    label: const Text('Novo token'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (tokens.isEmpty) const Text('Nenhum token criado ainda.'),
              for (final token in tokens) _TokenTile(token: token, onRevoke: () => _revoke(token.id)),
            ],
          ),
        };
      },
    );
  }
}

class _TokenTile extends StatelessWidget {
  final PublishToken token;
  final VoidCallback onRevoke;
  const _TokenTile({required this.token, required this.onRevoke});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: DartisanSpacing.s4, vertical: 4),
        title: Row(
          children: [
            Text('Token #${token.id}', style: DartisanFonts.mono(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(width: DartisanSpacing.s3),
            token.isRevoked
                ? const StatusPill(label: 'revogado', variant: StatusPillVariant.revoked)
                : const StatusPill(label: 'ativo', variant: StatusPillVariant.latest),
          ],
        ),
        subtitle: Text(
          token.isRevoked
              ? 'Revogado em ${formatDateTime(token.revokedAt!)}'
              : 'Criado em ${formatDateTime(token.createdAt)}'
                  '${token.lastUsedAt != null ? ' · último uso ${formatDateTime(token.lastUsedAt!)}' : ''}',
          style: TextStyle(color: colors.textFaint, fontSize: 13),
        ),
        trailing: token.isRevoked
            ? null
            : TextButton(
                onPressed: onRevoke,
                style: TextButton.styleFrom(foregroundColor: colors.danger),
                child: const Text('Revogar'),
              ),
      ),
    );
  }
}

class _CreatedTokenDialog extends StatelessWidget {
  final PublishTokenCreated created;
  const _CreatedTokenDialog({required this.created});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Token criado'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(DartisanSpacing.s3),
            decoration: BoxDecoration(
              color: context.colors.brassSoft,
              borderRadius: BorderRadius.circular(DartisanRadii.m - 2),
              border: Border.all(color: context.colors.brass.withValues(alpha: 0.4)),
            ),
            child: Text(
              'Copie agora: este token não será mostrado de novo.',
              style: TextStyle(fontWeight: FontWeight.w600, color: context.colors.brass),
            ),
          ),
          const SizedBox(height: DartisanSpacing.s3),
          Container(
            padding: const EdgeInsets.all(DartisanSpacing.s3),
            decoration: BoxDecoration(
              color: context.colors.codeBackground,
              borderRadius: BorderRadius.circular(DartisanRadii.m - 2),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: SelectableText(created.token, style: DartisanFonts.mono(fontSize: 13)),
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Clipboard.setData(ClipboardData(text: created.token)),
          icon: const Icon(Icons.copy),
          label: const Text('Copiar'),
        ),
        FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
      ],
    );
  }
}
